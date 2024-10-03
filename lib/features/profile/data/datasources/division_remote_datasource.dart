import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/error/failure.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/profile/data/models/division_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DivisionRemoteDatasource {
  Future<Either> getAllDivisions();
}

class DivisionRemoteDatasourceImpl extends DivisionRemoteDatasource {
  @override
  Future<Either> getAllDivisions() async {
    try {
      final divisions = await sl<SupabaseClient>().from('divisions').select();

      return Right(divisions.map((item) => DivisionModel.fromMap(item)).toList());
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
