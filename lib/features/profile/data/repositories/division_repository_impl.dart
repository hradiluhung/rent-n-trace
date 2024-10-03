import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/profile/data/datasources/division_remote_datasource.dart';
import 'package:rent_n_trace/features/profile/domain/repositories/division_repository.dart';

class DivisionRepositoryImpl extends DivisionRepository {
  @override
  Future<Either> getAllDivisions() async {
    return await sl<DivisionRemoteDatasource>().getAllDivisions();
  }
}
