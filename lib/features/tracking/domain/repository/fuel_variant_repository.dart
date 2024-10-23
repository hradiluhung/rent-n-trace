import 'package:dartz/dartz.dart';

abstract class FuelVariantRepository{
  Future<Either> getAllFuelVariants();
}