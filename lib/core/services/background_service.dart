import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:rent_n_trace/core/services/location_service.dart';
import 'package:rent_n_trace/dependencies.dart';

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

  print("Service started");

  service.on('start-tracking').listen((event) {
    locationService.positionStream.listen((position) async {
      final rentId = event?['rentId'];

      print("Location: ${position.latitude}, ${position.longitude}");
      print("Rent ID: $rentId");
    });
  });

  service.on('stop-service').listen((event) {
    print("Service stopped");
    service.stopSelf();
  });
}
