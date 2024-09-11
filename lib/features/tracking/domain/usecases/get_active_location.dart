import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/location_repository.dart';

class GetActiveLocation extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<LocationRepository>().getActiveLocation(params!);
  }
}
