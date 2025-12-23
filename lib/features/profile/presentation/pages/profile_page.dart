import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/widgets/app_alert.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/user_avatar.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/core/secrets/app_secrets.dart';
import 'package:rent_n_trace/features/auth/domain/entity/user.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';
import 'package:rent_n_trace/features/profile/domain/usecases/logout.dart';
import 'package:rent_n_trace/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        title: Text("Profil",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.foreground,
                )),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccess) {
              AppNavigator.pushAndRemove(context, const WelcomePage());
              context.read<UserCubit>().logout();
            }
          },
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is! UserAuthenticated) {
                return const SizedBox.shrink();
              }

              final user = state.user;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.divisionName == null) ...[
                      AppAlert(
                        icon: LucideIcons.info,
                        message:
                            "Kamu belum terdaftar di divisi manapun. Silakan lengkapi profil Anda.",
                        variant: AppAlertVariant.warning,
                        actions: BasicAppButton(
                          onPressed: () {
                            AppNavigator.push(context, const EditProfilePage());
                          },
                          width: 90.w,
                          height: 35.h,
                          variant: ButtonVariant.ghost,
                          content: Row(
                            children: [
                              Icon(
                                LucideIcons.edit2,
                                size: 16.r,
                                color: AppColors.foreground,
                              ),
                              SizedBox(width: 8.w),
                              Text("Lengkapi",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: AppColors.foreground)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                    _userDetail(context, user),
                    SizedBox(height: 20.h),
                    _logoutButton(context)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Builder(builder: (context) {
      return BasicReactiveButton(
        onPressed: () {
          context.read<ButtonStateCubit>().execute(usecase: Logout());
        },
        variant: ButtonVariant.outline,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.logOut, color: AppColors.foreground),
            SizedBox(width: 8.w),
            Text(
              "Logout",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.foreground,
                  ),
            )
          ],
        ),
      );
    });
  }

  Widget _userDetail(BuildContext context, User user) {
    return Card(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              name: user.fullName,
              imageUrl: "${AppSecrets.supabaseUrl}${user.photo}",
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullName,
                      style: Theme.of(context).textTheme.titleMedium),
                  if (user.divisionName != null) ...[
                    Text(
                      user.divisionName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14.sp, color: AppColors.secondForeground),
                    ),
                  ] else ...[
                    Text(
                      "Belum ada divisi",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.secondForeground.withOpacity(0.5)),
                    ),
                  ],
                  SizedBox(height: 4.h),
                  Text(
                    user.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 14.sp),
                  ),
                  Text(
                    "@${user.username}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            IconButton(
                iconSize: 18.r,
                onPressed: () {
                  AppNavigator.push(context, const EditProfilePage());
                },
                icon: const Icon(
                  LucideIcons.edit2,
                ))
          ],
        ),
      ),
    );
  }
}
