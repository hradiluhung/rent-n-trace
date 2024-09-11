import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/domain/repository/car_repository.dart';

class GetAvailableCars extends UseCase<Either, DateRangeReq> {
  @override
  Future<Either> call({DateRangeReq? params}) async {
    return await sl<CarRepository>().getAvailableCars(params!);
  }
}
