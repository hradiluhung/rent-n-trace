part of 'dependencies.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  // Core
  sl.registerLazySingleton(() => supabase.client);

  // Data sources
  sl.registerSingleton<AuthRemoteDatasource>(AuthRemoteDatasourceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // Use cases
  sl.registerSingleton<SignUp>(SignUp());
  sl.registerSingleton<Signin>(Signin());
  sl.registerSingleton<Logout>(Logout());
  sl.registerSingleton<GetCurrentUser>(GetCurrentUser());
}
