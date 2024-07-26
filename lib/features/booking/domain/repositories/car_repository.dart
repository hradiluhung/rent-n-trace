import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';

abstract interface class CarRepository {
  Future<Either<Failure, List<Car>>> getAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, List<Car>>> getNotAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, List<Car>>> getAllCars();

  Future<Either<Failure, Car>> getCarByRentId(String id);
}
