import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/common/widgets/my_back_button.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/show_snackbar.dart';
import 'package:rent_n_trace/core/utils/validators.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/auth_tetriary_button.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/divider_text.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MyBackButton(),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }

          if (state is AuthSuccessAuth) {
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBarLogo(),
                    SizedBox(height: 24.h),
                    Text(
                      "Selamat datang kembali!",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          "Silakan ",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "masuk",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppPallete.primaryColor1,
                              ),
                        ),
                        Text(
                          " ke aplikasi",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 74.h),
                    FormInputField(
                      controller: _emailTextController,
                      hintText: "johndoe@gmail.com",
                      labelText: "Email/Username",
                      prefixIcon: EvaIcons.emailOutline,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => emailValidator(value),
                    ),
                    SizedBox(height: 16.h),
                    FormInputField(
                      controller: _passwordTextController,
                      hintText: "Minimal 8 karakter",
                      labelText: "Password",
                      prefixIcon: EvaIcons.lockOutline,
                      isObscureText: true,
                      isRequired: true,
                      validator: (value) => passwordValidator(value),
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 16.h),
                    AuthPrimaryButton(
                        text: "Masuk",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthLogin(
                                    email: _emailTextController.text.trim(),
                                    password:
                                        _passwordTextController.text.trim(),
                                  ),
                                );
                          }
                        }),
                    SizedBox(height: 16.h),
                    const DividerText(text: "Atau"),
                    SizedBox(height: 16.h),
                    AuthTetriaryButton(
                      text: "Masuk dengan Google",
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLoginGoogle());
                      },
                      icon: EvaIcons.google,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
