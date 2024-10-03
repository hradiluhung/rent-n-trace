import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/fuel_cost_update_req.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
import 'package:rent_n_trace/core/common/models/stop_tracking_req.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/data/datasource/location_remote_datasource.dart';
import 'package:rent_n_trace/features/tracking/data/model/location_model.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/location_repository.dart';

class LocationRepositoryImpl extends LocationRepository {
  @override
  Future<Either> createInitialLocation(LocationCreationReq location) async {
    return await sl<LocationRemoteDatasource>().createInitialLocation(location);
  }

  @override
  Future<Either> getActiveLocation(String rentId) async {
    return await sl<LocationRemoteDatasource>().getActiveLocation(rentId);
  }

  @override
  Future<Either> stopActiveLocation(StopTrackingReq trackingData) async {
    return await sl<LocationRemoteDatasource>().stopActiveLocation(trackingData);
  }

  @override
  Future<Either> updateActiveLocation(Location location) async {
    return await sl<LocationRemoteDatasource>().updateActiveLocation(
      LocationModel.fromEntity(location),
    );
  }

  @override
  Future<Either> updateFuelCost(FuelCostUpdateReq fuelCostUpdateReq) async {
    return await sl<LocationRemoteDatasource>().updateFuelCost(fuelCostUpdateReq);
  }
}
