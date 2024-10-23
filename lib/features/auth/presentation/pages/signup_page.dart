import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/validator/validator.dart';
import 'package:rent_n_trace/core/common/models/user_creation_req.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/signup_detail_page.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/signin_instead.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();
  final FocusNode passwordConfirmFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 40.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headingText(context),
            SizedBox(height: 24.h),
            _signupForm(context),
            SizedBox(height: 24.h),
            const SignInInstead(),
          ],
        ),
      ),
    );
  }

  Widget _signupForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _emailField(),
          SizedBox(height: 16.h),
          _passwordField(),
          SizedBox(height: 16.h),
          _confirmPasswordField(),
          SizedBox(height: 16.h),
          _continueButton(context),
        ],
      ),
    );
  }

  Widget _headingText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Daftar ',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.foreground,
                ),
            children: [
              TextSpan(
                text: 'Rent n Trace',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Daftar untuk melakukan peminjaman mobil',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _emailField() {
    return FormInputField(
      controller: _emailCon,
      hintText: 'contoh@mail.com',
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => emailValidator(value),
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
      focusNode: passwordFocusNode,
      nextFocusNode: passwordConfirmFocusNode,
      prefixIcon: LucideIcons.lock,
      validator: (value) => passwordValidator(value),
      required: true,
    );
  }

  Widget _confirmPasswordField() {
    return FormInputField(
      controller: _confirmPasswordCon,
      hintText: 'Password harus sama',
      labelText: 'Konfirmasi Password',
      obscureText: true,
      focusNode: passwordConfirmFocusNode,
      textInputAction: TextInputAction.done,
      prefixIcon: LucideIcons.lock,
      validator: (value) {
        if (value != _passwordCon.text) {
          return 'Password tidak sama';
        }
        return null;
      },
      required: true,
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          AppNavigator.push(
            context,
            SignUpDetailPage(
              userCreationReq: UserCreationReq(
                email: _emailCon.text,
                password: _passwordCon.text,
              ),
            ),
          );
        }
      },
      title: "Lanjut",
    );
  }
}
