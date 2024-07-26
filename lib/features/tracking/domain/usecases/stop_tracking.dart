import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/tracking/domain/repositories/location_repository.dart';

class StopTracking implements UseCase<String, StopTrackingParams> {
  final LocationRepository repository;

  StopTracking(this.repository);

  @override
  Future<Either<Failure, String>> call(StopTrackingParams params) async {
    return await repository.stopTracking(
      rentId: params.rentId,
      positions: params.positions,
      distance: params.distance,
    );
  }
}

class StopTrackingParams {
  String rentId;
  List<LatLng> positions;
  double distance;

  StopTrackingParams({
    required this.rentId,
    required this.positions,
    required this.distance,
  });
}
