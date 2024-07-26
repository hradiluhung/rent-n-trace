import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class GetRentById implements UseCase<Rent, GetRentByIdParams> {
  final RentRepository repository;

  GetRentById(this.repository);

  @override
  Future<Either<Failure, Rent>> call(GetRentByIdParams params) async {
    return await repository.getRentById(params.rentId);
  }
}

class GetRentByIdParams {
  final String rentId;

  GetRentByIdParams({required this.rentId});
}
