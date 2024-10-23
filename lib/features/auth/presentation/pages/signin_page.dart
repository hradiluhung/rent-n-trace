import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/validator/validator.dart';
import 'package:rent_n_trace/core/common/models/user_signin_req.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/auth/domain/entity/user.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/signin.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/signup_instead.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_cubit.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _emailOrUsernameCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailure) {
              AppSnackbar.show(context, state.message, AppSnackbarType.error);
            }

            if (state is ButtonSuccess) {
              final user = state.data as User;
              context.read<UserCubit>().updateAuthenticated(user);
              AppNavigator.pushAndRemove(context, const LandingPage());
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 40.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headingText(context),
                SizedBox(height: 24.h),
                _signinForm(context),
                SizedBox(height: 24.h),
                const SignUpInstead(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headingText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Silakan masuk ',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.foreground,
                ),
            children: [
              TextSpan(
                text: '\nRent n Trace',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Masuk dengan akun yang sudah terdaftar',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _signinForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _emailField(),
          SizedBox(height: 16.h),
          _passwordField(),
          SizedBox(height: 16.h),
          _submitButton(context),
        ],
      ),
    );
  }

  Widget _emailField() {
    return FormInputField(
      controller: _emailOrUsernameCon,
      hintText: 'contoh@mail.com atau johndoe',
      labelText: 'Email atau Username',
      prefixIcon: LucideIcons.mail,
      required: true,
    );
  }

  Widget _passwordField() {
    return FormInputField(
      controller: _passwordCon,
      hintText: 'Minimal 8 karakter',
      labelText: 'Password',
      obscureText: true,
      prefixIcon: LucideIcons.lock,
      validator: (value) => passwordValidator(value),
      textInputAction: TextInputAction.done,
      required: true,
    );
  }

  Widget _submitButton(BuildContext context) {
    return Builder(builder: (context) {
      return BasicReactiveButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<ButtonStateCubit>().execute(
                usecase: Signin(),
                params: UserSigninReq(
                  emailOrUsername: _emailOrUsernameCon.text,
                  password: _passwordCon.text,
                ));
          }
        },
        title: "Masuk",
      );
    });
  }
}
