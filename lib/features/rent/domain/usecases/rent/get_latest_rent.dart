import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/repository/rent_repository.dart';

class GetLatestRent implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<RentRepository>().getLatestRent();
  }
}
