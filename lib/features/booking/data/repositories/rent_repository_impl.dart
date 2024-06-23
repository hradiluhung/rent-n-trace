import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/booking/data/datasources/rent_remote_data_source.dart';
import 'package:rent_n_trace/features/booking/data/models/rent_model.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';
import 'package:uuid/uuid.dart';

class RentRepositoryImpl implements RentRepository {
  RentRemoteDataSource rentRemoteDataSource;

  RentRepositoryImpl(this.rentRemoteDataSource);

  @override
  Future<Either<Failure, List<Rent>>> getCurrentMonthRents(
      String userId) async {
    try {
      final rents = await rentRemoteDataSource.getCurrentMonthRents(
        userId,
      );
      return Right(rents);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Rent?>> getLatestRent(String userId) async {
    try {
      final rent = await rentRemoteDataSource.getLatestRent(userId);
      return Right(rent);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      RentModel rent = RentModel(
        startDateTime: startDate,
        endDateTime: endDate,
        destination: destination,
        userId: userId,
        id: const Uuid().v1(),
        carId: carId,
        need: need,
        needDetail: needDetail,
        driverId: driverId,
      );

      final createdRent = await rentRemoteDataSource.createRent(rent);
      return Right(createdRent);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
