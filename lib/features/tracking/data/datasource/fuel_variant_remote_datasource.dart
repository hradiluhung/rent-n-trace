import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/tracking/data/model/fuel_variant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FuelVariantRemoteDatasource {
  Future<Either> getAllFuelVariants();
}

class FuelVariantRemoteDatasourceImpl extends FuelVariantRemoteDatasource {
  @override
  Future<Either> getAllFuelVariants() async {
    try {
      final fuelVariants = await sl<SupabaseClient>().from('fuel_variants').select();

      print("Fuel Variants: $fuelVariants");

      return Right(fuelVariants.map((item) => FuelVariantModel.fromMap(item)).toList());
    } on PostgrestException catch (e) {
      print("PostgrestException: $e");
      return Left(Failure(e.message));
    } catch (e) {
      print("Error: $e");
      return Left(Failure(e.toString()));
    }
  }
}
