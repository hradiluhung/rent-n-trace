import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/models/fuel_cost_update_req.dart';
import 'package:rent_n_trace/core/common/models/location_creation_req.dart';
import 'package:rent_n_trace/core/common/models/stop_tracking_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/data/models/rent_history_model.dart';
import 'package:rent_n_trace/features/tracking/data/model/location_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LocationRemoteDatasource {
  Future<Either> createInitialLocation(LocationCreationReq location);
  Future<Either> getActiveLocation(String rentId);
  Future<Either> updateActiveLocation(LocationModel location);
  Future<Either> stopActiveLocation(StopTrackingReq trackingData);
  Future<Either> updateFuelCost(FuelCostUpdateReq fuelCostUpdateReq);
}

class LocationRemoteDatasourceImpl extends LocationRemoteDatasource {
  @override
  Future<Either> createInitialLocation(LocationCreationReq location) async {
    try {
      final locationData = await sl<SupabaseClient>().from('real_time_locations').insert({
        'rent_id': location.rentId,
        'lat': location.lat,
        'long': location.long,
      }).select();

      await sl<SupabaseClient>().from('rents').update({
        'status': RentStatus.tracked,
      }).eq('id', location.rentId!);

      return Right(LocationModel.fromMap(locationData.first));
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
  Future<Either> updateActiveLocation(LocationModel location) async {
    try {
      await sl<SupabaseClient>().from('real_time_locations').update({
        'lat': location.lat,
        'long': location.long,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('rent_id', location.rentId);

      return Right(location);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> stopActiveLocation(StopTrackingReq trackingData) async {
    try {
      // Update rent status
      final rents = await sl<SupabaseClient>()
          .from('rents')
          .update({
            'status': RentStatus.completed,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', trackingData.rentId!)
          .select();

      if (rents.isEmpty) {
        return Left(Failure('No rent found with the given ID'));
      }

      // Delete real-time location
      await sl<SupabaseClient>()
          .from('real_time_locations')
          .delete()
          .eq('id', trackingData.locationId!);

      // Call RPC to update car and driver status
      await sl<SupabaseClient>().rpc(
        'update_car_driver_status',
        params: {
          'p_rent_id': trackingData.rentId,
        },
      );

      // Insert rent history
      final rentHistory = await sl<SupabaseClient>().from('rent_histories').insert({
        'rent_id': trackingData.rentId,
        'latlongs': trackingData.latlongs,
        'distance': trackingData.distance,
        'fuel_cost': trackingData.fuelCost,
      }).select();

      if (rentHistory.isEmpty) {
        return Left(Failure('Failed to insert rent history'));
      }

      return Right(RentHistoryModel.fromMap(rentHistory.first));
    } on PostgrestException catch (e) {
      print("PostgrestException: $e");
      return Left(Failure(e.message));
    } catch (e) {
      print("Unknown error: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> updateFuelCost(FuelCostUpdateReq fuelCostUpdateReq) async {
    try {
      await sl<SupabaseClient>().from('rent_histories').update({
        'fuel_cost': fuelCostUpdateReq.fuelCost,
      }).eq('rent_id', fuelCostUpdateReq.rentId!);

      return const Right("Biaya penggunaan bensin berhasil diupdate!");
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
