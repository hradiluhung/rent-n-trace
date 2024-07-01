import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/utils/validators.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
          PrimaryButton(
            text: "Masuk",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                      AuthLogin(
                        email: _emailTextController.text.trim(),
                        password: _passwordTextController.text.trim(),
                      ),
                    );
              }
            },
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
