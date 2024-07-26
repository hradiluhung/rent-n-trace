import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/color_converter.dart';
import 'package:rent_n_trace/core/utils/confirmation_dialog.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';
import 'package:rent_n_trace/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:rent_n_trace/features/profile/presentation/widgets/alert_card.dart';

class ProfilePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showDialogLogout() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
          dismissText: "Batal",
          confirmText: "Yakin?",
          title: "Konfirmasi Logout",
          content: "Apakah anda yakin ingin logout dari aplikasi ini?",
          onConfirm: () {
            context.read<AuthBloc>().add(AuthLogout());
          },
          onDismiss: () {
            Navigator.pop(context);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessLogout) {
          showToast(
            context: context,
            message: "Berhasil Logout!",
            status: WidgetStatus.success,
          );
          Navigator.pushAndRemoveUntil(
            context,
            WelcomePage.route(),
            (route) => false,
          );
        }
      },
      child: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserLoggedIn) {
            final userData = state.user;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Profil Anda",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w, bottom: 42.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userData.division == "" || userData.division == null) ...[
                          AlertCard(
                            title: "Lengkapi Profil Anda",
                            message: "Anda belum melengkapi profil anda. Silakan lengkapi!",
                            buttonText: "Lengkapi",
                            onButtonClicked: () {
                              Navigator.push(
                                context,
                                ProfileEditPage.route(userData),
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                        ],
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(18.r),
                          decoration: BoxDecoration(
                            color: AppPalette.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppPalette.greyColor.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        ProfileEditPage.route(userData),
                                      );
                                    },
                                    child: const Icon(
                                      EvaIcons.editOutline,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: ClipOval(
                                      child: Image.network(
                                        userData.photo ??
                                            "https://ui-avatars.com/api/?name=${userData.fullName}&background=${colorToHex(AppPalette.primaryColor4)}&color=fff&size=256",
                                        width: 84.r,
                                        height: 84.r,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 24.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData.fullName,
                                          style: Theme.of(context).textTheme.headlineMedium,
                                        ),
                                        Text(
                                          userData.email,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        if (userData.division != "" || userData.division != null) ...[
                                          Text(
                                            userData.division!,
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "Konfigurasi",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 16.h),
                        InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () {
                            // TODO: Navigate to Change Password Page
                          },
                          splashColor: Colors.grey.withOpacity(0.3),
                          highlightColor: Colors.grey.withOpacity(0.1),
                          child: Ink(
                            height: 48.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppPalette.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppPalette.greyColor.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(EvaIcons.lockOutline),
                                SizedBox(width: 18.w),
                                Text(
                                  "Ubah Password",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () {
                            // TODO: Navigate to Settings Page
                          },
                          splashColor: Colors.grey.withOpacity(0.3),
                          highlightColor: Colors.grey.withOpacity(0.1),
                          child: Ink(
                            height: 48.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppPalette.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppPalette.greyColor.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(EvaIcons.settingsOutline),
                                SizedBox(width: 18.w),
                                Text(
                                  "Pengaturan",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SecondaryButton(
                          text: "Logout",
                          icon: EvaIcons.logOutOutline,
                          onPressed: () {
                            _showDialogLogout();
                          },
                          isFullWidth: true,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
