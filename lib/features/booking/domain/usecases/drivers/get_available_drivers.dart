import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/driver.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/driver_repository.dart';

class GetAvailableDrivers implements UseCase<List<Driver>?, NoParams> {
  final DriverRepository driverRepository;
  GetAvailableDrivers(this.driverRepository);

  @override
  Future<Either<Failure, List<Driver>?>> call(NoParams params) async {
    return await driverRepository.getAvailableDrivers();
  }
}
