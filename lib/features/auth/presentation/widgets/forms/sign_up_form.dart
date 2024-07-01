import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/extensions/string_extension.dart';
import 'package:rent_n_trace/core/utils/validators.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
    return Form(
      key: formKey,
      child: Column(
        children: [
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
          PrimaryButton(
            text: "Daftar",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                      AuthSignUp(
                        email: emailTextController.text.trim(),
                        fullName:
                            fullNameTextController.text.trim().toTitleCase(),
                        password: passwordTextController.text.trim(),
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
