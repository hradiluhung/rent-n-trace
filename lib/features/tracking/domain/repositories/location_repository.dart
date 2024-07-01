import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/tracking/domain/entities/location.dart';

abstract interface class LocationRepository {
  Future<Either<Failure, Stream<Location>>> getRealTimeLocation(String rentId);
}
