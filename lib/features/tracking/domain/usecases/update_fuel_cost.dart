import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/fuel_cost_update_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/location_repository.dart';

class UpdateFuelCost extends UseCase<Either, FuelCostUpdateReq> {
  @override
  Future<Either> call({FuelCostUpdateReq? params}) async {
    return await sl<LocationRepository>().updateFuelCost(params!);
  }
}
