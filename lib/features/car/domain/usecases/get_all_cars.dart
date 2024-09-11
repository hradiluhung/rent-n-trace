import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/domain/repository/car_repository.dart';

class GetAllCars implements UseCase<Either, dynamic> {
  @override 
  Future<Either> call({params}) async {
    return await sl<CarRepository>().getAllCars();
  }
}
