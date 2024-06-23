import 'package:rent_n_trace/core/constants/statuses.dart';
import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/booking/data/models/rent_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RentRemoteDataSource {
  Future<List<RentModel>> getCurrentMonthRents(String userId);

  Future<RentModel?> getLatestRent(String userId);

  Future<RentModel> createRent(RentModel rent);
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
      final endOfMonth = DateTime(now.year, now.month + 1, 1)
          .subtract(const Duration(days: 1));

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

      return RentModel.fromJson(rent.first).copyWith(
        carName: rent.first['cars']['name'],
        carImage: rent.first['cars']['images'][0],
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RentModel> createRent(RentModel rent) async {
    try {
      // check whether is there active rent
      final activeRents = await supabaseClient.from('rents').select('*').or(
          'status.eq.${RentStatus.approved}, status.eq.${RentStatus.tracked}');
      if (activeRents.isNotEmpty) {
        throw const ServerException('Terdapat sewa yang masih aktif');
      }

      final rentData =
          await supabaseClient.from('rents').insert(rent.toJson()).select();

      return RentModel.fromJson(rentData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
