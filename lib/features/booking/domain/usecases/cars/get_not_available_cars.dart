import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/car_repository.dart';

class GetNotAvailableCars
    implements UseCase<List<Car>, GetNotAvailableCarsParams> {
  final CarRepository carRepository;
  GetNotAvailableCars(this.carRepository);

  @override
  Future<Either<Failure, List<Car>>> call(GetNotAvailableCarsParams params) {
    return carRepository.getNotAvailableCar(
        startDate: params.startDate, endDate: params.endDate);
  }
}

class GetNotAvailableCarsParams {
  final DateTime startDate;
  final DateTime endDate;

  GetNotAvailableCarsParams({required this.startDate, required this.endDate});
}
