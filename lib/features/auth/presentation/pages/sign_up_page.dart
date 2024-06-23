import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/app_bar_logo.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/common/widgets/my_back_button.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/extensions/string_extension.dart';
import 'package:rent_n_trace/core/utils/show_snackbar.dart';
import 'package:rent_n_trace/core/utils/validators.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/auth_tetriary_button.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/divider_text.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailTextController = TextEditingController();
  final fullNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextController.dispose();
    fullNameTextController.dispose();
    passwordTextController.dispose();
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
                context, HomePage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader(loadingText: "Mendaftar");
          }
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppBarLogo(),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Text(
                              "Silakan ",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              "daftar",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: AppPallete.primaryColor1,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          "untuk menggunakan aplikasi! ",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 48.h),
                        FormInputField(
                          controller: emailTextController,
                          hintText: "johndoe@gmail.com",
                          labelText: "Email",
                          prefixIcon: EvaIcons.emailOutline,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => emailValidator(value),
                          isRequired: true,
                        ),
                        SizedBox(height: 16.h),
                        FormInputField(
                          controller: fullNameTextController,
                          hintText: "John Doe",
                          labelText: "Nama Lengkap",
                          prefixIcon: EvaIcons.personOutline,
                          isRequired: true,
                        ),
                        SizedBox(height: 16.h),
                        FormInputField(
                          controller: passwordTextController,
                          hintText: "Minimal 8 karakter",
                          labelText: "Password",
                          prefixIcon: EvaIcons.lockOutline,
                          isObscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) => passwordValidator(value),
                          isRequired: true,
                        ),
                        SizedBox(height: 16.h),
                        AuthPrimaryButton(
                          text: "Daftar",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthSignUp(
                                      email: emailTextController.text.trim(),
                                      fullName: fullNameTextController.text
                                          .trim()
                                          .toTitleCase(),
                                      password:
                                          passwordTextController.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
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
                  )),
            ),
          );
        },
      ),
    );
  }
}
