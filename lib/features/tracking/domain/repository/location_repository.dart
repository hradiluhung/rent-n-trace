import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';

abstract class LocationRepository {
  Future<Either> createInitialLocation(LocationCreationReq location);
  Future<Either> getActiveLocation(String rentId);
  Future<Either> updateActiveLocation(Location location);
  Future<Either> stopActiveLocation(Location location);
}
