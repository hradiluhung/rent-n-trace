import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/data/datasource/rent_remote_datasrouce.dart';
import 'package:rent_n_trace/features/rent/domain/repository/rent_repository.dart';

class RentRepositoryImpl extends RentRepository {
  @override
  Future<Either> getCurrMonthRents() async {
    return await sl<RentRemoteDatasource>().getCurrMonthRents();
  }

  @override
  Future<Either> getLatestRent() async {
    return await sl<RentRemoteDatasource>().getLatestRent();
  }

  @override
  Future<Either> getRentById(String id) async {
    return await sl<RentRemoteDatasource>().getRentDetail(id);
  }

  @override
  Future<Either> createRent(RentCreationReq rent) async {
    return await sl<RentRemoteDatasource>().createRent(rent);
  }
}
