import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/booking/domain/entities/driver.dart';

abstract interface class DriverRepository {
  Future<Either<Failure, List<Driver>?>> getAvailableDrivers();
}
