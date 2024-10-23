import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/domain/repository/fuel_variant_repository.dart';

class GetAllFuelVariants extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<FuelVariantRepository>().getAllFuelVariants();
  }
}
