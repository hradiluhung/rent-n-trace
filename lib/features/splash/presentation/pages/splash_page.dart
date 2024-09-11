import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/config/assets/app_json.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';
import 'package:rent_n_trace/features/landing/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashUnauthenticated) {
          AppNavigator.pushReplacement(context, const WelcomePage());
        }
        if (state is SplashAuthenticated) {
          AppNavigator.pushReplacement(context, const LandingPage());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rent N Trace',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Lottie.asset(
                AppJson.screenLoading,
                height: 120.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
