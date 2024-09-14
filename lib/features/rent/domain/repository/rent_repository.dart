import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';

abstract class RentRepository {
  // Rent
  Future<Either> getLatestRent();
  Future<Either> getDetailRent(String id);
  Future<Either> createRent(RentCreationReq rent);

  // Rent History
  Future<Either> getCurrMonthRentHistories();
  Future<Either> getAllRentHistories();
  Future<Either> getDetailRentHistory(String id);
}
