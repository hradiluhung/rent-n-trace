import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';

abstract class DriverRepository {
  Future<Either> getAvailableDrivers(DateRangeReq dateRange);
}
