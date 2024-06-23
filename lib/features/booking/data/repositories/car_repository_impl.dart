import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/booking/data/datasources/car_remote_data_source.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/car_repository.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource carRemoteDataSource;
  CarRepositoryImpl(this.carRemoteDataSource);

  @override
  Future<Either<Failure, List<Car>>> getAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final cars = await carRemoteDataSource.getAvailableCar(
        startDate: startDate,
        endDate: endDate,
      );
      return right(cars);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Car>>> getAllCars() async {
    try {
      final cars = await carRemoteDataSource.getAllCars();
      return right(cars);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Car>>> getNotAvailableCar(
      {required DateTime startDate, required DateTime endDate}) async {
    try {
      final cars = await carRemoteDataSource.getNotAvailableCar(
        startDate: startDate,
        endDate: endDate,
      );
      return right(cars);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
