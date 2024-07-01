import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/features/tracking/data/datasources/location_remote_datasource.dart';
import 'package:rent_n_trace/features/tracking/domain/entities/location.dart';
import 'package:rent_n_trace/features/tracking/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRemoteDatasource realTimeLocationRemoteDatasource;
  LocationRepositoryImpl(this.realTimeLocationRemoteDatasource);

  @override
  Future<Either<Failure, Stream<Location>>> getRealTimeLocation(
      String rentId) async {
    try {
      final location =
          realTimeLocationRemoteDatasource.getRealTimeLocation(rentId);
      return right(location);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
