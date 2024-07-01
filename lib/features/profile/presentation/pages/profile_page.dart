import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/utils/show_toast.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessLogout) {
          showToast(context: context, message: "Berhasil Logout!");
          Navigator.pushAndRemoveUntil(
            context,
            WelcomePage.route(),
            (route) => false,
          );
        }
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessLogout) {
            showToast(context: context, message: "Berhasil Logout!");
            Navigator.pushAndRemoveUntil(
              context,
              WelcomePage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader(loadingText: "Logout");
          }
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Center(
                  child: Column(
                    children: [
                      SecondaryButton(
                        text: "Logout",
                        icon: EvaIcons.logOutOutline,
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogout());
                        },
                        isFullWidth: true,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
