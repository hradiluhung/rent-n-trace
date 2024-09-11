import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/driver/data/datasources/driver_remote_datasource.dart';
import 'package:rent_n_trace/features/driver/domain/repository/driver_repository.dart';

class DriverRepositoryImpl extends DriverRepository {
  @override
  Future<Either> getAvailableDrivers(DateRangeReq params) async {
    return await sl<DriverRemoteDatasource>().getAvailableDrivers(params);
  }
}
