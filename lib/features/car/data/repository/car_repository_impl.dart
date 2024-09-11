import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/data/datasources/car_remote_datasource.dart';
import 'package:rent_n_trace/features/car/domain/repository/car_repository.dart';

class CarRepositoryImpl extends CarRepository {
  @override
  Future<Either> getAllCars() async {
    return await sl<CarRemoteDatasource>().getAllCars();
  }

  @override
  Future<Either> getCarById(String id) async {
    return await sl<CarRemoteDatasource>().getCarById(id);
  }

  @override
  Future<Either> getAvailableCars(DateRangeReq dateRange) async {
    return await sl<CarRemoteDatasource>().getAvailableCars(dateRange);
  }
}
