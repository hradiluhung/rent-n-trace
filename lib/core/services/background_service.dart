import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/realm/realm_config.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/services/location_service.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/lat_lng.dart' as realm_latlng;
import 'package:rent_n_trace/features/tracking/data/models/realm/local_locations.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/start_tracking.dart';
import 'package:rent_n_trace/init_dependencies.dart';

Future<void> initializeBackroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

RealmConfig realmConfig = RealmConfig();

void onStart(ServiceInstance service) async {
  try {
    DartPluginRegistrant.ensureInitialized();
    debugPrint("Inisialisasi dependencies...");
    await initializeDateFormatting('id_ID', null);
    await initDependencies();
    debugPrint("Inisialisasi dependencies selesai.");

    Realm realm = realmConfig.getRealm();
    LocationService locationService = LocationService();
    StreamSubscription<Position>? locationStream;
    bool isPaused = false;

    service.on('stopService').listen((event) {
      debugPrint("Service stopped");
      locationStream?.cancel();
      service.stopSelf();

      // TODO: Delete soon
      // realm.write(() {
      //   realm.deleteAll<LocalLocations>();
      // });
    });

    service.on('pauseService').listen((event) {
      isPaused = true;
      debugPrint("Service paused");
    });

    service.on('resumeService').listen((event) {
      isPaused = false;
      debugPrint("Service resumed");
    });

    service.on('startService').listen((event) {
      final rentId = event?['rentId'] as String;
      debugPrint("Rent ID: $rentId");
      var realmLocations = LocalLocations(DateTime.now(), 0, locations: []);

      realm.write(() {
        realm.add(realmLocations);
      });

      locationStream = locationService.positionStream.listen((position) async {
        if (isPaused) {
          debugPrint("Service is paused, skipping position update");
          return;
        }

        debugPrint("Position: $position");

        realm.write(() {
          realmLocations.distance += realmLocations.locations.length > 1
              ? Geolocator.distanceBetween(
                  realmLocations.locations.last.latitude,
                  realmLocations.locations.last.longitude,
                  position.latitude,
                  position.longitude,
                )
              : 0;
          realmLocations.timestamp = DateTime.now();
          realmLocations.locations.add(realm_latlng.LatLng(position.latitude, position.longitude));
        });

        final result = await serviceLocator<StartTracking>()
            .call(StartTrackingParams(rentId: rentId, latitude: position.latitude, longitude: position.longitude));

        result.fold((error) => debugPrint("Error: $error"), (message) => debugPrint("Message: $message"));

        debugPrint(
            "Jarak: ${realmLocations.distance.toStringAsFixed(2)} meters. Update terakhir: ${realmLocations.timestamp.toFormattedHHmmddMMMMyyyy()}");
      });
    });
  } catch (e) {
    debugPrint("Terjadi kesalahan: $e");
  }
}
