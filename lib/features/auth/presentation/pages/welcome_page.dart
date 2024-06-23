import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/login_page.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/sign_up_page.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/auth_secondary_button.dart';

class WelcomePage extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const WelcomePage());
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/welcome_image.png",
                      height: 200.h,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      "Selamat Datang di Rent n' Trace",
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Lakukan booking peminjaman mobil secara online",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                Column(
                  children: [
                    AuthPrimaryButton(
                        text: "Buat Akun Baru",
                        onPressed: () {
                          Navigator.push(
                            context,
                            SignUpPage.route(),
                          );
                        }),
                    SizedBox(height: 12.h),
                    AuthSecondaryButton(
                        text: "Sudah Punya Akun",
                        onPressed: () {
                          Navigator.push(
                            context,
                            LoginPage.route(),
                          );
                        }),
                    SizedBox(height: 42.h),
                    Text(
                      "powered by Kampung Maghfirah",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
