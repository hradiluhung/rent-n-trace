import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
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
  Future<Either> stopActiveLocation(Location location) async {
    return await sl<LocationRemoteDatasource>().stopActiveLocation(
      LocationModel.fromEntity(location),
    );
  }

  @override
  Future<Either> updateActiveLocation(Location location) async {
    return await sl<LocationRemoteDatasource>().updateActiveLocation(
      LocationModel.fromEntity(location),
    );
  }
}
