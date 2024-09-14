import 'package:dartz/dartz.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/core/usecase/usecase.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/rent/domain/repository/rent_repository.dart';

class CreateRent extends UseCase<Either, RentCreationReq> {
  @override
  Future<Either> call({RentCreationReq? params}) async {
    return await sl<RentRepository>().createRent(params!);
  }
}
