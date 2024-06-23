import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class GetCurrentMonthRents
    implements UseCase<List<Rent>, GetCurrentMonthRentsParams> {
  RentRepository rentRepository;
  GetCurrentMonthRents(this.rentRepository);

  @override
  Future<Either<Failure, List<Rent>>> call(
      GetCurrentMonthRentsParams params) async {
    return await rentRepository.getCurrentMonthRents(params.userId);
  }
}

class GetCurrentMonthRentsParams {
  final String userId;

  GetCurrentMonthRentsParams(this.userId);
}
