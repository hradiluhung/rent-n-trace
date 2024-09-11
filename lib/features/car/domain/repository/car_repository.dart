import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';

abstract class CarRepository {
  Future<Either> getAllCars();
  Future<Either> getCarById(String id);
  Future<Either> getAvailableCars(DateRangeReq dateRange);
}
