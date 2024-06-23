import 'package:rent_n_trace/core/error/exceptions.dart';
import 'package:rent_n_trace/features/booking/data/models/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class DriverRemoteDataSource {
  Future<List<DriverModel>?> getAvailableDriver();
}

class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final SupabaseClient supabaseClient;

  DriverRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<DriverModel>?> getAvailableDriver() async {
    try {
      final drivers = await supabaseClient
          .from('drivers')
          .select('*')
          .eq('is_available', true)
          .eq('is_active', true);

      return drivers.map((driver) => DriverModel.fromJson(driver)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
