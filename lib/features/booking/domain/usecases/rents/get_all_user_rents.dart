import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/domain/repositories/rent_repository.dart';

class GetAllUserRents implements UseCase<List<Rent>, String> {
  final RentRepository rentRepository;
  GetAllUserRents(this.rentRepository);

  @override
  Future<Either<Failure, List<Rent>>> call(String params) {
    return rentRepository.getAllUserRents(params);
  }
}
