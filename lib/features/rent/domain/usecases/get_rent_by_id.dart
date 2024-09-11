import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/repository/rent_repository.dart';

class GetRentById extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<RentRepository>().getRentById(params!);
  }
}
