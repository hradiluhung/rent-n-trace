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
      final driverIds = await sl<SupabaseClient>()
          .from('rents')
          .select('driver_id')
          .or('and(start_date.gte.${dateRange.startDate}, start_date.lte.${dateRange.endDate}), and(end_date.gte.${dateRange.startDate}, end_date.lte.${dateRange.endDate})')
          .or('status.eq.approved,status.eq.tracked');

      final drivers = await sl<SupabaseClient>()
          .from('drivers')
          .select()
          .not('id', 'in', driverIds.map((item) => item['driver_id']).toList());

      return Right(drivers.map((item) => DriverModel.fromMap(item)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
