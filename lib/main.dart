import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/theme/theme.dart';
import 'package:rent_n_trace/core/utils/show_snackbar.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/car/car_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/driver/driver_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/home_page.dart';
import 'package:rent_n_trace/init_dependencies.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await initDependencies();

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
    return ToastificationWrapper(
      child: ScreenUtilInit(
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
                return BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      showSnackBar(context, state.message);
                    }

                    if (state is AuthSuccessLogout) {
                      showSnackBar(context, "Berhasil");
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Loader();
                    }
                    return const HomePage();
                    // return ChooseCarPage(
                    //   rent: Rent.createInitial(
                    //     id: "1",
                    //     userId: "2",
                    //     startDateTime:
                    //         DateTime.now().add(const Duration(days: 4)),
                    //     endDateTime:
                    //         DateTime.now().add(const Duration(days: 8)),
                    //     destination: "Jakarta",
                    //     need: "Pribadi",
                    //     needDetail: "Ada Deh",
                    //   ),
                    // );
                    // return Scaffold(
                    //   appBar: AppBar(
                    //     actions: [
                    //       IconButton(
                    //         icon: const Icon(Icons.logout),
                    //         onPressed: () {
                    //           context.read<AuthBloc>().add(AuthLogout());
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                );
              }
              return const WelcomePage();
            },
          ),
        ),
      ),
    );
  }
}
