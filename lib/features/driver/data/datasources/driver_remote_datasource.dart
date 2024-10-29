import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/driver/data/model/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DriverRemoteDatasource {
  Future<Either> getAvailableDrivers(DateRangeReq dateRange);
}

class DriverRemoteDatasourceImpl implements DriverRemoteDatasource {
  @override
  Future<Either> getAvailableDrivers(DateRangeReq dateRange) async {
    try {
      final driverIds = await sl<SupabaseClient>().rpc('get_available_driver_ids', params: {
        'date_start': dateRange.startDate.toIso8601String(),
        'date_end': dateRange.endDate.toIso8601String()
      });

      final drivers =
          await sl<SupabaseClient>().from('drivers').select().not('id', 'in', driverIds);

      return Right(drivers.map((item) => DriverModel.fromMap(item)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
