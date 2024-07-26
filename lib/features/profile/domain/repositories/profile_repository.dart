import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/error/failures.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, User>> updateUserProfile({
    required User user,
    File? photo,
  });
}
