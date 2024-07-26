import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';
import 'package:rent_n_trace/core/error/failures.dart';

abstract interface class LocationRepository {
  Future<Either<Failure, String>> startTracking({
    required String rentId,
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, String>> stopTracking({
    required String rentId,
    required List<LatLng> positions,
    required double distance,
  });
}
