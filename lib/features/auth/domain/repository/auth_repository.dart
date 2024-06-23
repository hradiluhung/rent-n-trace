import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String fullName,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> loginWithGoogle();

  Future<Either<Failure, void>> logout();
}
