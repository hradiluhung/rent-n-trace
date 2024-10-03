import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/profile/domain/repositories/division_repository.dart';

class GetAllDivisions extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<DivisionRepository>().getAllDivisions();
  }
}
