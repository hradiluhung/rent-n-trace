import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/booking/data/datasources/driver_remote_data_source.dart';
import 'package:rent_n_trace/features/booking/domain/entities/driver.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/driver_repository.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDataSource driverRemoteDataSource;
  DriverRepositoryImpl(this.driverRemoteDataSource);

  @override
  Future<Either<Failure, List<Driver>?>> getAvailableDrivers() async {
    try {
      final drivers = await driverRemoteDataSource.getAvailableDriver();
      return right(drivers);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
