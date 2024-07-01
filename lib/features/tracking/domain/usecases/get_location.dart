import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/tracking/domain/entities/location.dart';
import 'package:rent_n_trace/features/tracking/domain/repositories/location_repository.dart';

class GetLocation implements UseCase<Stream<Location>, String> {
  LocationRepository locationRepository;
  GetLocation(this.locationRepository);
  @override
  Future<Either<Failure, Stream<Location>>> call(String params) async {
    return await locationRepository.getRealTimeLocation(params);
  }
}
