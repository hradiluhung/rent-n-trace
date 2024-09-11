import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/domain/repository/car_repository.dart';

class GetCarById extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async{
    return await sl<CarRepository>().getCarById(params!);
  }
}
