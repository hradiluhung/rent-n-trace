import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/car_repository.dart';

class GetAllCars implements UseCase<List<Car>?, NoParams> {
  final CarRepository carRepository;
  GetAllCars(this.carRepository);
  @override
  Future<Either<Failure, List<Car>>> call(NoParams params) async {
    return await carRepository.getAllCars();
  }
}
