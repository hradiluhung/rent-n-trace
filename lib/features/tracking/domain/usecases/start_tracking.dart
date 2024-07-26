import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/tracking/domain/repositories/location_repository.dart';

class StartTracking implements UseCase<String, StartTrackingParams> {
  final LocationRepository repository;
  StartTracking(this.repository);

  @override
  Future<Either<Failure, String>> call(StartTrackingParams params) async {
    return await repository.startTracking(
      rentId: params.rentId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class StartTrackingParams {
  final String rentId;
  final double latitude;
  final double longitude;

  StartTrackingParams({
    required this.rentId,
    required this.latitude,
    required this.longitude,
  });
}
