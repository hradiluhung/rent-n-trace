part of 'dependencies.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  final config = Configuration.local([LatLng.schema, LocationTrackingRecord.schema]);
  final realm = Realm(config);

  /* Core */
  sl.registerLazySingleton(() => supabase.client);
  sl.registerLazySingleton(() => realm);

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
  sl.registerSingleton<GetLatestRent>(GetLatestRent());
  sl.registerSingleton<GetDetailRent>(GetDetailRent());
  sl.registerSingleton<CreateRent>(CreateRent());

  // RentHistory
  sl.registerSingleton<GetCurrMonthRentHistories>(GetCurrMonthRentHistories());
  sl.registerSingleton<GetAllRentHistories>(GetAllRentHistories());
  sl.registerSingleton<GetDetailRentHistory>(GetDetailRentHistory());

  // Car
  sl.registerSingleton<GetAllCars>(GetAllCars());
  sl.registerSingleton<GetCarById>(GetCarById());
  sl.registerSingleton<GetAvailableCars>(GetAvailableCars());

  // Driver
  sl.registerSingleton<GetAvailableDrivers>(GetAvailableDrivers());

  // Location
  sl.registerSingleton<CreateInitialLocation>(CreateInitialLocation());
  sl.registerSingleton<GetActiveLocation>(GetActiveLocation());
  sl.registerSingleton<UpdateActiveLocation>(UpdateActiveLocation());
  sl.registerSingleton<StopActiveLocation>(StopActiveLocation());
  sl.registerSingleton<UpdateFuelCost>(UpdateFuelCost());
}
