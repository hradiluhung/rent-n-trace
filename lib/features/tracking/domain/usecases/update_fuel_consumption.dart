import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class UpdateFuelConsumption implements UseCase<Rent, UpdateFuelConsumptionParams> {
  final RentRepository rentRepository;
  UpdateFuelConsumption(this.rentRepository);

  @override
  Future<Either<Failure, Rent>> call(UpdateFuelConsumptionParams params) async {
    return await rentRepository.updateFuelConsumption(params.rentId, params.fuelConsumption);
  }
}

class UpdateFuelConsumptionParams {
  final String rentId;
  final int fuelConsumption;

  UpdateFuelConsumptionParams({required this.rentId, required this.fuelConsumption});
}
