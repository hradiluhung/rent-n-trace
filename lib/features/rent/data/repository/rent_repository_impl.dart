import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/data/datasource/rent_remote_datasrouce.dart';
import 'package:rent_n_trace/features/rent/domain/repository/rent_repository.dart';

class RentRepositoryImpl extends RentRepository {
  @override
  Future<Either> getCurrMonthRentHistories() async {
    return await sl<RentRemoteDatasource>().getCurrMonthRentHistories();
  }

  @override
  Future<Either> getLatestRent() async {
    return await sl<RentRemoteDatasource>().getLatestRent();
  }

  @override
  Future<Either> getDetailRent(String id) async {
    return await sl<RentRemoteDatasource>().getDetailRent(id);
  }

  @override
  Future<Either> createRent(RentCreationReq rent) async {
    return await sl<RentRemoteDatasource>().createRent(rent);
  }

  @override
  Future<Either> getAllRentHistories() async {
    return await sl<RentRemoteDatasource>().getAllRentHistories();
  }

  @override
  Future<Either> getDetailRentHistory(String id) async {
    return await sl<RentRemoteDatasource>().getDetailRentHistory(id);
  }
}
