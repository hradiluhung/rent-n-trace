import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/validator/validator.dart';
import 'package:rent_n_trace/core/common/models/user_creation_req.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/auth/domain/usecases/signup.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/signin_page.dart';
import 'package:rent_n_trace/features/auth/presentation/widgets/signin_instead.dart';

class SignUpDetailPage extends StatelessWidget {
  final UserCreationReq userCreationReq;
  SignUpDetailPage({super.key, required this.userCreationReq});

  final TextEditingController _fullNameCon = TextEditingController();
  final TextEditingController _usernameCon = TextEditingController();
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
              AppSnackbar.show(
                  context,
                  "Berhasil mendaftar. Silakan hubungi admin untuk verifikasi akun",
                  AppSnackbarType.success);
              AppNavigator.pushAndRemove(context, SignInPage());
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
                _signupForm(context),
                SizedBox(height: 24.h),
                const SignInInstead(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headingText(BuildContext context) {
    return Text('Harap lengkapi profil Anda ',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.foreground,
            ));
  }

  Widget _signupForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _fullNameField(),
          SizedBox(height: 16.h),
          _usernameField(),
          SizedBox(height: 16.h),
          _submitButton(context),
        ],
      ),
    );
  }

  Widget _fullNameField() {
    return FormInputField(
      controller: _fullNameCon,
      hintText: 'John Doe',
      labelText: 'Nama Lengkap',
      prefixIcon: LucideIcons.user2,
      required: true,
    );
  }

  Widget _usernameField() {
    return FormInputField(
      controller: _usernameCon,
      hintText: 'johndoe',
      labelText: 'Username',
      prefixIcon: LucideIcons.user2,
      validator: usernameValidator,
      required: true,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _submitButton(BuildContext context) {
    return Builder(builder: (context) {
      return BasicReactiveButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            userCreationReq.fullName = _fullNameCon.text;
            userCreationReq.username = _usernameCon.text;

            context.read<ButtonStateCubit>().execute(usecase: SignUp(), params: userCreationReq);
          }
        },
        title: "Daftar",
      );
    });
  }
}
