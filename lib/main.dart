import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as map_box;
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_n_trace/core/config/theme/app_theme.dart';
import 'package:rent_n_trace/core/services/background_service.dart';
import 'package:rent_n_trace/dependencies.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/pages/splash_page.dart';

Future<void> checkPemission() async {
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
  await initializeDependencies();
  await initializeDateFormatting('id_ID', null);
  await checkPemission();
  await initializeBackgroundService();

  const accessToken = String.fromEnvironment("PUBLIC_ACCESS_TOKEN");
  map_box.MapboxOptions.setAccessToken(accessToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, _) => BlocProvider(
        create: (context) => SplashCubit()..init(),
        child: MaterialApp(
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ),
      ),
    );
  }
}
