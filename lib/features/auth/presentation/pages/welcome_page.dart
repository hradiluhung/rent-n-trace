import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/logo.dart';
import 'package:rent_n_trace/core/config/assets/app_images.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/signin_page.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        hideBack: true,
        title: Logo(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              Image.asset(
                AppImages.car,
                height: 200.h,
              ),
              SizedBox(height: 18.h),
              Text(
                "Selamat Datang di \nRent n' Trace",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                "Lakukan booking peminjaman mobil secara online",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 72.h),
              Column(
                children: [
                  BasicAppButton(
                    onPressed: () {
                      AppNavigator.push(context, SignupPage());
                    },
                    title: "Buat Akun Baru",
                  ),
                  SizedBox(height: 8.h),
                  BasicAppButton(
                    onPressed: () {
                      AppNavigator.push(context, SignInPage());
                    },
                    title: "Sudah Punya Akun",
                    variant: ButtonVariant.outline,
                  ),
                  SizedBox(height: 42.h),
                  RichText(
                    text: TextSpan(
                      text: 'powered by ',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Kampung Maghfirah',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
