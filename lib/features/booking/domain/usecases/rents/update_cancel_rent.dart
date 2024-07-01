
import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class UpdateCancelRent implements UseCase<String, UpdateCancelRentParams> {
  final RentRepository rentRepository;
  UpdateCancelRent(this.rentRepository);

  @override
  Future<Either<Failure, String>> call(UpdateCancelRentParams params) async{
    return await rentRepository.updateCancelRent(params.rentId);
  }
  
}

class UpdateCancelRentParams {
  final String rentId;

  UpdateCancelRentParams(this.rentId);
}