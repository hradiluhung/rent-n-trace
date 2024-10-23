import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/data/datasource/fuel_variant_remote_datasource.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/fuel_variant_repository.dart';

class FuelVariantRepositoryImpl extends FuelVariantRepository {
  @override
  Future<Either> getAllFuelVariants() async {
    return await sl<FuelVariantRemoteDatasource>().getAllFuelVariants();
  }
}
