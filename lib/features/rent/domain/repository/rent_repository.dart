import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';

abstract class RentRepository {
  Future<Either> getCurrMonthRents();
  Future<Either> getLatestRent();
  Future<Either> getRentById(String id);
  Future<Either> createRent(RentCreationReq rent);
}
