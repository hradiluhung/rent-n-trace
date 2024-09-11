import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/data/model/location_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LocationRemoteDatasource {
  Future<Either> createInitialLocation(LocationCreationReq location);
  Future<Either> getActiveLocation(String rentId);
  Future<Either> updateActiveLocation(LocationModel location);
  Future<Either> stopActiveLocation(LocationModel location);
}

class LocationRemoteDatasourceImpl extends LocationRemoteDatasource {
  @override
  Future<Either> createInitialLocation(LocationCreationReq location) async {
    try {
      await sl<SupabaseClient>().from('real_time_locations').insert({
        'rent_id': location.rentId,
        'lat': location.lat,
        'long': location.long,
      });

      await sl<SupabaseClient>().from('rents').update({
        'status': RentStatus.tracked,
      }).eq('id', location.rentId!);

      return Right(location);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> getActiveLocation(String rentId) async {
    try {
      final location =
          await sl<SupabaseClient>().from('real_time_locations').select().eq('rent_id', rentId);

      if (location.isEmpty) {
        return const Right(null);
      }

      return Right(LocationModel.fromMap(location.first));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> stopActiveLocation(LocationModel location) {
    // TODO: implement stopActiveLocation
    throw UnimplementedError();
  }

  @override
  Future<Either> updateActiveLocation(LocationModel location) async {
    try {
      await sl<SupabaseClient>().from('real_time_locations').update({
        'lat': location.lat,
        'long': location.long,
      }).eq('rent_id', location.rentId);

      return Right(location);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
