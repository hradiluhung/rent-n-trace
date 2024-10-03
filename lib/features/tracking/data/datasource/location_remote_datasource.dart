import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/constants/car_status.dart';
import 'package:rent_n_trace/core/common/constants/driver_status.dart';
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
      print("PostgrestException: ${e.message}");
      return Left(Failure(e.message));
    } catch (e) {
      print("Unhandeled Exception: $e");
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

      print("Location Updated: $location");
      return Right(location);
    } on PostgrestException catch (e) {
      print("PostgrestException: ${e.message}");
      return Left(Failure(e.message));
    } catch (e) {
      print("Unhandeled Exception: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> stopActiveLocation(StopTrackingReq trackingData) async {
    try {
      final rents = await sl<SupabaseClient>()
          .from('rents')
          .update({
            'status': RentStatus.completed,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', trackingData.rentId!)
          .select();

      await sl<SupabaseClient>()
          .from('real_time_locations')
          .delete()
          .eq('id', trackingData.locationId!);

      final carId = rents.first['car_id'];
      await sl<SupabaseClient>().from('cars').update({
        'status': CarStatus.available,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', carId);

      final rentHistory = await sl<SupabaseClient>().from('rent_histories').insert({
        'rent_id': trackingData.rentId,
        'latlongs': trackingData.latlongs,
        'distance': trackingData.distance,
        'fuel_cost': trackingData.fuelCost,
      }).select();

      final driverId = rents.first['driver_id'];

      if (driverId != null) {
        await sl<SupabaseClient>().from('drivers').update({
          'status': DriverStatus.available,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', driverId);
      }

      return Right(RentHistoryModel.fromMap(rentHistory.first));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
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
