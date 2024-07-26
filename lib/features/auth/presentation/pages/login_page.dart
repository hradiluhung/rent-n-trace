import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/circular_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/divider_text.dart';
import 'package:rent_n_trace/core/common/widgets/layouts/user_layout.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/forms/login_form.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showToast(
              context: context,
              message: state.message,
              status: WidgetStatus.error,
            );
          }

          if (state is AuthSuccessAuth) {
            Navigator.pushAndRemoveUntil(
              context,
              UserLayout.route(),
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircularButton(
                        icon: EvaIcons.close,
                        onClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const AppBarLogo(),
                  SizedBox(height: 24.h),
                  Text(
                    "Selamat datang kembali!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 6.h),
                  RichText(
                    text: TextSpan(
                      text: "Silakan ",
                      style: Theme.of(context).textTheme.headlineMedium,
                      children: [
                        TextSpan(
                          text: "masuk",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppPalette.primaryColor2,
                              ),
                        ),
                        TextSpan(
                          text: "ke aplikasi",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 74.h),
                  const LoginForm(),
                  SizedBox(height: 16.h),
                  const DividerText(text: "Atau"),
                  SizedBox(height: 16.h),
                  SecondaryButton(
                    text: "Masuk dengan Google",
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLoginGoogle());
                    },
                    icon: EvaIcons.google,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
