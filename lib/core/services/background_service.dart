import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/realm/models/lat_lang.dart';
import 'package:rent_n_trace/core/common/realm/models/location_tracking_record.dart';
import 'package:rent_n_trace/core/services/location_service.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';
import 'package:rent_n_trace/features/tracking/domain/usecases/update_active_location.dart';

Future<void> initializeBackgroundService() async {
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

void onStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();

  await initializeDependencies();
  LocationService locationService = LocationService();
  Realm realm = sl<Realm>();
  StreamSubscription<Position>? locationStream;

  service.on('start-tracking').listen((event) {
    final rentId = event?['rentId'];
    final locationId = event?['locationId'];
    var locationRecord = LocationTrackingRecord(DateTime.now(), 0, locations: []);

    realm.write(() {
      realm.add(locationRecord);
    });

    locationStream = locationService.positionStream.listen((position) async {
      // Update real time location
      await sl<UpdateActiveLocation>().call(
        params: Location(
          id: locationId,
          rentId: rentId,
          lat: position.latitude,
          long: position.longitude,
        ),
      );

      // Update local locations
      realm.write(() {
        try {
          if (locationRecord.locations.isNotEmpty) {
            locationRecord.distance += locationRecord.locations.length > 1
                ? Geolocator.distanceBetween(
                    locationRecord.locations.last.latitude,
                    locationRecord.locations.last.longitude,
                    position.latitude,
                    position.longitude,
                  )
                : 0;
          }

          locationRecord.timestamp = DateTime.now();
          locationRecord.locations.add(LatLng(position.latitude, position.longitude));

          print("Save local location success");
        } catch (e) {
          print("Error saving local location: $e");
        }
      });
    });
  });

  service.on('pause-tracking').listen((event) {
    print("Tracking paused");
    locationStream?.pause();
  });

  service.on('resume-tracking').listen((event) {
    print("Tracking resumed");
    locationStream?.resume();
  });

  service.on('finish-tracking').listen((event) {
    print("Finish tracking");
    service.stopSelf();
    locationStream?.cancel();
    realm.write(() {
      realm.deleteAll<LocationTrackingRecord>();
    });
  });

  service.on('stop-service').listen((event) {
    print("Service stopped");
    service.stopSelf();
  });
}
