import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/location_repository.dart';

class CreateInitialLocation extends UseCase<Either, LocationCreationReq> {
  @override
  Future<Either> call({LocationCreationReq? params}) async {
    return await sl<LocationRepository>().createInitialLocation(params!);
  }
}
