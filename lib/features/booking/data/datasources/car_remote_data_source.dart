import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/booking/data/models/car_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CarRemoteDataSource {
  Future<List<CarModel>> getAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<CarModel>> getAllCars();

  Future<List<CarModel>> getNotAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  });
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final SupabaseClient supabaseClient;
  CarRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CarModel>> getAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final rents = await supabaseClient
          .from('rents')
          .select('car_id')
          .or('and(start_datetime.gte.$startDate, start_datetime.lte.$endDate), and(end_datetime.gte.$startDate, end_datetime.lte.$endDate)')
          .eq('status', 'approved');

      final cars = await supabaseClient
          .from('cars')
          .select('*')
          .not('id', 'in', rents.map((rent) => rent['car_id']).toList());

      return cars.map((car) => CarModel.fromJson(car)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CarModel>> getNotAvailableCar({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final rents = await supabaseClient
          .from('rents')
          .select('car_id')
          .or('and(start_datetime.gte.$startDate, start_datetime.lte.$endDate), and(end_datetime.gte.$startDate, end_datetime.lte.$endDate)')
          .eq('status', 'approved');

      final cars = await supabaseClient
          .from('cars')
          .select('*, rents(start_datetime, end_datetime)')
          .inFilter('id', rents.map((rent) => rent['car_id']).toList());

      return cars.map((car) => CarModel.fromJson(car)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CarModel>> getAllCars() async {
    try {
      final cars = await supabaseClient.from('cars').select('*');

      return cars.map((car) => CarModel.fromJson(car)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
