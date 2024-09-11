import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/driver/domain/repository/driver_repository.dart';

class GetAvailableDrivers extends UseCase<Either, DateRangeReq> {
  @override
  Future<Either> call({DateRangeReq? params}) async {
    return await sl<DriverRepository>().getAvailableDrivers(params!);
  }
}
