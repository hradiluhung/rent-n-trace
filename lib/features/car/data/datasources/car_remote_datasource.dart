import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/car/data/models/car_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CarRemoteDatasource {
  Future<Either> getAllCars();
  Future<Either> getCarById(String id);
  Future<Either> getAvailableCars(DateRangeReq dateRange);
}

class CarRemoteDatasourceImpl implements CarRemoteDatasource {
  @override
  Future<Either> getAllCars() async {
    try {
      final cars = await sl<SupabaseClient>().from('cars').select();

      return Right(cars.map((item) => CarModel.fromMap(item)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either> getCarById(String id) async {
    try {
      final car = await sl<SupabaseClient>().from('cars').select().eq('id', id);

      if (car.isEmpty) {
        return Left(Failure('Mobil tidak ditemukan'));
      }

      return Right(CarModel.fromMap(car.first));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure("Silakan coba lagi!"));
    }
  }

  @override
  Future<Either> getAvailableCars(DateRangeReq dateRange) async {
    try {
      final carIds =
          await sl<SupabaseClient>().rpc('get_unavailable_car_ids', params: {
        'date_start': dateRange.startDate.toIso8601String(),
        'date_end': dateRange.endDate.toIso8601String()
      });

      final cars = await sl<SupabaseClient>()
          .from('cars')
          .select()
          .not('id', 'in', carIds)
          .neq('status', 'maintenance');

      print("Jumlah Mobil: ${carIds.length}");

      return Right(cars.map((item) => CarModel.fromMap(item)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
