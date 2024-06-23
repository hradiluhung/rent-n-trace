import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/car_repository.dart';

class GetAvailableCars implements UseCase<List<Car>, GetAvailableCarsParams> {
  final CarRepository carRepository;
  GetAvailableCars(this.carRepository);

  @override
  Future<Either<Failure, List<Car>>> call(
      GetAvailableCarsParams params) async {
    return await carRepository.getAvailableCar(
        startDate: params.startDate, endDate: params.endDate);
  }
}

class GetAvailableCarsParams {
  final DateTime startDate;
  final DateTime endDate;

  GetAvailableCarsParams({required this.startDate, required this.endDate});
}
