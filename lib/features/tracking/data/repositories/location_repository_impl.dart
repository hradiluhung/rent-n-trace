import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/tracking/data/datasources/location_remote_datasource.dart';
import 'package:rent_n_trace/features/tracking/data/models/tracking_history_model.dart';
import 'package:rent_n_trace/features/tracking/domain/repositories/location_repository.dart';
import 'package:uuid/uuid.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRemoteDatasource realTimeLocationRemoteDatasource;
  LocationRepositoryImpl(this.realTimeLocationRemoteDatasource);

  @override
  Future<Either<Failure, String>> startTracking({
    required String rentId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final message = await realTimeLocationRemoteDatasource.startTracking(
          rentId: rentId, latitude: latitude, longitude: longitude);

      return Right(message);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> stopTracking({required String rentId, required List<LatLng> positions, required double distance}) async {
    try {
      final trackingHistory = TrackingHistoryModel(
        id: const Uuid().v1(),
        positions: positions,
        rentId: rentId,
        distance: distance,
      );
      final message =
          await realTimeLocationRemoteDatasource.stopTracking(rentId: rentId, trackingHistory: trackingHistory);

      return Right(message);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
