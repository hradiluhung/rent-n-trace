import 'package:get_it/get_it.dart';
import 'package:rent_n_trace/core/secrets/app_secrets.dart';
import 'package:rent_n_trace/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:rent_n_trace/features/auth/data/repository/auth_repository_impl.dart';
import 'package:rent_n_trace/features/auth/domain/repository/auth_repository.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/get_current_user.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/signin.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/signup.dart';
import 'package:rent_n_trace/features/home/domain/usecases/logout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dependencies.main.dart';
