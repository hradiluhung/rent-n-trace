import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/booking/data/models/rent_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RentRemoteDataSource {
  Future<List<RentModel>> getCurrentMonthRents(String userId);

  Future<RentModel?> getLatestRent(String userId);

  Future<RentModel> createRent(RentModel rent);

  Future<String> updateCancelRent(String rentId);

  Future<List<RentModel>> getAllUserRents(String userId);

  Future<RentModel> getRentById(String rentId);

  Future<RentModel> updateFuelConsumption(String rentId, int fuelConsumption);
}

class RentRemoteDataSourceImpl implements RentRemoteDataSource {
  final SupabaseClient supabaseClient;

  RentRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<RentModel>> getCurrentMonthRents(
    String userId,
  ) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));

      final rents = await supabaseClient
          .from('rents')
          .select('*, cars (name)')
          .eq('status', RentStatus.done)
          .eq('user_id', userId)
          .gte('created_at', startOfMonth.toIso8601String())
          .lte('created_at', endOfMonth.toIso8601String());

      return rents
          .map(
            (rent) => RentModel.fromJson(rent).copyWith(
              carName: rent['cars']['name'],
            ),
          )
          .toList();
    } catch (e) {
      print("ERROR: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RentModel?> getLatestRent(String userId) async {
    try {
      final rent = await supabaseClient
          .from('rents')
          .select('*, cars (name, images)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1);

      if (rent.isEmpty) {
        return null;
      }

      String? driverName;
      if (rent.first['driver_id'] != null) {
        final driver = await supabaseClient
            .from('drivers')
            .select('name')
            .eq('id', rent.first['driver_id'])
            .single();
        driverName = driver['name'];
      }

      return RentModel.fromJson(rent.first).copyWith(
        carName: rent.first['cars']['name'],
        carImage: rent.first['cars']['images'][0],
        driverName: driverName,
      );
    } catch (e) {
      print("Error: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RentModel> createRent(RentModel rent) async {
    try {
      final activeRents = await supabaseClient
          .from('rents')
          .select('*')
          .or('status.eq.${RentStatus.approved}, status.eq.${RentStatus.tracked}');
      if (activeRents.isNotEmpty) {
        throw const ServerException('Terdapat sewa yang masih aktif');
      }

      final rentData = await supabaseClient.from('rents').insert(rent.toJson()).select();

      // update car status
      await supabaseClient.from('cars').update({'status': CarStatus.booked}).eq('id', rent.carId!);

      return RentModel.fromJson(rentData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateCancelRent(String rentId) async {
    try {
      await supabaseClient
          .from('rents')
          .update({'status': RentStatus.cancelled, 'updated_at': 'now()'})
          .eq('id', rentId)
          .select();

      return "Booking berhasil dibatalkan";
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RentModel>> getAllUserRents(String userId) async {
    try {
      final rents =
          await supabaseClient.from('rents').select('*, cars (name, images)').eq('user_id', userId);

      return rents
          .map((rent) => RentModel.fromJson(rent)
              .copyWith(carName: rent['cars']['name'], carImage: rent['cars']['images'][0]))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RentModel> getRentById(String rentId) async {
    try {
      final rent = await supabaseClient
          .from('rents')
          .select('*, cars (name, images, fuel_consumption)')
          .eq('id', rentId)
          .single();

      String? driverName;
      if (rent['driver_id'] != null) {
        final driver = await supabaseClient
            .from('drivers')
            .select('name')
            .eq('id', rent['driver_id'])
            .single();
        driverName = driver['name'];
      }

      return RentModel.fromJson(rent).copyWith(
        carName: rent['cars']['name'],
        carImage: rent['cars']['images'][0],
        fuelConsumption: rent['cars']['fuel_consumption'],
        driverName: driverName,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RentModel> updateFuelConsumption(String rentId, int fuelConsumption) async {
    try {
      final rent = await supabaseClient
          .from('rents')
          .update({'fuel_consumption': fuelConsumption, 'updated_at': 'now()'})
          .eq('id', rentId)
          .select();

      return RentModel.fromJson(rent.first);
    } catch (e) {
      print("Error: $e");
      throw ServerException(e.toString());
    }
  }
}
