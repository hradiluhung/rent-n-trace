import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';

abstract interface class RentRepository {
  Future<Either<Failure, List<Rent>>> getCurrentMonthRents(String userId);

  Future<Either<Failure, Rent?>> getLatestRent(String userId);

  Future<Either<Failure, Rent>> createRent({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required String destination,
    required String need,
    required String needDetail,
    String? driverId,
    String? driverName,
    String? carId,
    String? carName,
  });

  Future<Either<Failure, String>> updateCancelRent(String rentId);

  Future<Either<Failure, List<Rent>>> getAllUserRents(String userId);

  Future<Either<Failure, Rent>> getRentById(String rentId);
}
