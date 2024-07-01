part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initRent();
  _initCar();
  _initDriver();
  _initLocation();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initCar() {
  serviceLocator
    // Data sources
    ..registerFactory<CarRemoteDataSource>(
      () => CarRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<CarRepository>(
      () => CarRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => GetAvailableCars(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllCars(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetNotAvailableCars(
        serviceLocator(),
      ),
    )
    // Blocs
    ..registerLazySingleton(
      () => CarBloc(
        getAvailableCars: serviceLocator(),
        getAllCars: serviceLocator(),
        getNotAvailableCars: serviceLocator(),
      ),
    );
}

void _initDriver() {
  serviceLocator
    // Data sources
    ..registerFactory<DriverRemoteDataSource>(
      () => DriverRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<DriverRepository>(
      () => DriverRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => GetAvailableDrivers(
        serviceLocator(),
      ),
    )
    // Blocs
    ..registerLazySingleton(
      () => DriverBloc(
        getAvailableDrivers: serviceLocator(),
      ),
    );
}

void _initLocation() {
  serviceLocator
    // Data sources
    ..registerFactory<LocationRemoteDatasource>(
      () => LocationRemoteDatasourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<LocationRepository>(
      () => LocationRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => GetLocation(
        serviceLocator(),
      ),
    )
    // Blocs
    ..registerLazySingleton(
      () => LocationBloc(
        getLocation: serviceLocator(),
      ),
    );
}

void _initRent() {
  serviceLocator
    // Data sources
    ..registerFactory<RentRemoteDataSource>(
      () => RentRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<RentRepository>(
      () => RentRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => GetCurrentMonthRents(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CreateRent(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetLatestRent(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateCancelRent(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => GetAllUserRents(
          serviceLocator(),
        ))
    // Blocs
    ..registerLazySingleton(
      () => RentBloc(
        getCurrentMonthRent: serviceLocator(),
        createRent: serviceLocator(),
        getApprovedOrTrackedRent: serviceLocator(),
        updateCancelRent: serviceLocator(),
        getAllUserRents: serviceLocator(),
      ),
    );
}

void _initAuth() {
  serviceLocator
    // Data sources
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLoginGoogle(
        serviceLocator(),
      ),
    )
    // Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        appUserCubit: serviceLocator(),
        currentUser: serviceLocator(),
        userLogout: serviceLocator(),
        userLogin: serviceLocator(),
        userLoginGoogle: serviceLocator(),
      ),
    );
}
