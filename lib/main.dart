import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as map_box;
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/layouts/user_layout.dart';
import 'package:rent_n_trace/core/services/background_service.dart';
import 'package:rent_n_trace/core/theme/theme.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/car/car_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/driver/driver_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/location/location_bloc.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/rent/tracking_rent_bloc.dart';
import 'package:rent_n_trace/init_dependencies.dart';

Future<void> checkPermission() async {
  bool notificationDenied = await Permission.notification.isDenied;
  if (notificationDenied) {
    await Permission.notification.request();
  }

  bool locationDenied = await Permission.location.isDenied;
  if (locationDenied) {
    await Permission.location.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkPermission();
  await initializeDateFormatting('id_ID', null);
  await initDependencies();
  await initializeBackroundService();

  const accessToken = String.fromEnvironment("PUBLIC_ACCESS_TOKEN");
  map_box.MapboxOptions.setAccessToken(accessToken);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<RentBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<DriverBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<CarBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<LocationBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProfileBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<TrackingRentBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rent n Trace',
        theme: AppTheme.lightThemeMode,
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return const UserLayout();
              // return const TrackingResultPage(
              //   rentId: "f319de10-077d-106b-952d-1f3bb01f0e83",
              // );
            }
            return const WelcomePage();
          },
        ),
      ),
    );
  }
}
