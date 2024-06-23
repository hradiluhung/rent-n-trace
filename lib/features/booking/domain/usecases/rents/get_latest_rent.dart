import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class GetLatestRent implements UseCase<Rent?, GetLatestRentParams> {
  RentRepository rentRepository;
  GetLatestRent(this.rentRepository);

  @override
  Future<Either<Failure, Rent?>> call(GetLatestRentParams params) async {
    return await rentRepository.getLatestRent(params.userId);
  }
}

class GetLatestRentParams {
  final String userId;

  GetLatestRentParams(this.userId);
}
