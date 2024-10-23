import 'package:rent_n_trace/features/tracking/domain/entity/fuel_variant.dart';

sealed class DisplayAllFuelVariantsState {}

class DisplayAllFuelVariantsLoading extends DisplayAllFuelVariantsState {
  final FuelVariant placeholder = FuelVariant(
    id: 'id',
    name: 'name',
    price: 0,
  );
}

class DisplayAllFuelVariantsLoaded extends DisplayAllFuelVariantsState {
  final List<FuelVariant> fuelVariants;
  DisplayAllFuelVariantsLoaded(this.fuelVariants);
}

class DisplayAllFuelVariantsFailed extends DisplayAllFuelVariantsState {
  final String message;
  DisplayAllFuelVariantsFailed(this.message);
}
