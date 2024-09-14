import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/stop_tracking_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/location_repository.dart';

class StopActiveLocation extends UseCase<Either, StopTrackingReq> {
  @override
  Future<Either> call({StopTrackingReq? params}) async {
    return await sl<LocationRepository>().stopActiveLocation(params!);
  }
}
