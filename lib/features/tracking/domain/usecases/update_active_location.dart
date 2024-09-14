import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/entity/location.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/location_repository.dart';

class UpdateActiveLocation extends UseCase<Either, Location> {
  @override
  Future<Either> call({Location? params}) async {
    return await sl<LocationRepository>().updateActiveLocation(params!);
  }
}
