part of 'dependencies.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  /* Core */
  sl.registerLazySingleton(() => supabase.client);

  /* Data sources */
  sl.registerSingleton<AuthRemoteDatasource>(AuthRemoteDatasourceImpl());
  sl.registerSingleton<RentRemoteDatasource>(RentRemoteDatasrouceImpl());
  sl.registerSingleton<CarRemoteDatasource>(CarRemoteDatasourceImpl());
  sl.registerSingleton<DriverRemoteDatasource>(DriverRemoteDatasourceImpl());
  sl.registerSingleton<LocationRemoteDatasource>(LocationRemoteDatasourceImpl());

  /* Repositories */
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<RentRepository>(RentRepositoryImpl());
  sl.registerSingleton<CarRepository>(CarRepositoryImpl());
  sl.registerSingleton<DriverRepository>(DriverRepositoryImpl());
  sl.registerSingleton<LocationRepository>(LocationRepositoryImpl());

  /* Use cases */
  // Auth
  sl.registerSingleton<SignUp>(SignUp());
  sl.registerSingleton<Signin>(Signin());
  sl.registerSingleton<Logout>(Logout());
  sl.registerSingleton<GetCurrentUser>(GetCurrentUser());

  // Rent
  sl.registerSingleton<GetCurrMonthRents>(GetCurrMonthRents());
  sl.registerSingleton<GetLatestRent>(GetLatestRent());
  sl.registerSingleton<GetRentById>(GetRentById());
  sl.registerSingleton<CreateRent>(CreateRent());

  // Car
  sl.registerSingleton<GetAllCars>(GetAllCars());
  sl.registerSingleton<GetCarById>(GetCarById());
  sl.registerSingleton<GetAvailableCars>(GetAvailableCars());

  // Driver
  sl.registerSingleton<GetAvailableDrivers>(GetAvailableDrivers());

  // Location
  sl.registerSingleton<CreateInitialLocation>(CreateInitialLocation());
  sl.registerSingleton<GetActiveLocation>(GetActiveLocation());
}
