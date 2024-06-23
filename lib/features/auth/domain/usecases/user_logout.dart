import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/error/failures.dart';
import 'package:rent_n_trace/core/usecase/use_case.dart';
import 'package:rent_n_trace/features/auth/domain/repository/auth_repository.dart';

class UserLogout implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  UserLogout(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}
