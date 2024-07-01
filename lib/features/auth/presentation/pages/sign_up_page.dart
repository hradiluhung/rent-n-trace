import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/circular_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/divider_text.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/show_toast.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/check_email_verification_page.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/forms/sign_up_form.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
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
                context, CheckEmailVerificationPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader(loadingText: "Mendaftar");
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppBarLogo(),
                          SizedBox(height: 24.h),
                          RichText(
                            text: TextSpan(
                              text: "Silakan ",
                              style: Theme.of(context).textTheme.headlineMedium,
                              children: [
                                TextSpan(
                                  text: "daftar",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppPalette.primaryColor2,
                                      ),
                                ),
                                TextSpan(
                                  text: "\nuntuk menggunakan aplikasi!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 48.h),
                          const SignUpForm(),
                          SizedBox(height: 16.h),
                          const DividerText(text: "Atau"),
                          SizedBox(height: 16.h),
                          SecondaryButton(
                            text: "Daftar dengan Google",
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthLoginGoogle());
                            },
                            icon: EvaIcons.google,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
