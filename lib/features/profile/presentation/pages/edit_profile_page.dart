import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/helpers/image_picker/image_picker.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/validator/validator.dart';
import 'package:rent_n_trace/core/common/models/update_user_req.dart';
import 'package:rent_n_trace/core/common/widgets/app_bottom_sheet.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/core/common/widgets/user_avatar.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/auth/domain/entity/user.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/profile/domain/usecases/update_profile.dart';
import 'package:rent_n_trace/features/profile/presentation/bloc/display_all_divisions_cubit.dart';
import 'package:rent_n_trace/features/profile/presentation/bloc/display_all_divisions_state.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _fullNameCon = TextEditingController();
  final TextEditingController _usernameCon = TextEditingController();
  final TextEditingController _divisionCon = TextEditingController();
  File? _newPhoto;
  String? divisionId;
  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _newPhoto = pickedImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final userState = context.read<UserCubit>().state;
    if (userState is UserAuthenticated) {
      _emailCon.text = userState.user.email;
      _fullNameCon.text = userState.user.fullName;
      _usernameCon.text = userState.user.username;
      _divisionCon.text = userState.user.divisionName ?? "";

      setState(() {
        divisionId = userState.user.divisionId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Edit Profil",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 20.sp,
                color: AppColors.secondForeground,
              ),
        ),
      ),
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
              AppSnackbar.show(context, "Berhasil update profile", AppSnackbarType.success);
              AppNavigator.pushAndRemove(context, const LandingPage(defaultIndex: 3));
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                final user = (state as UserAuthenticated).user;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _avatarField(context, user),
                      SizedBox(height: 20.h),
                      _emailField(),
                      SizedBox(height: 20.h),
                      _fullNameField(),
                      SizedBox(height: 20.h),
                      _usernameField(),
                      SizedBox(height: 20.h),
                      _selectDivisionField(context),
                      SizedBox(height: 20.h),
                      _submitButton(context, user),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectDivisionField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomSheet.display(
          context,
          _divisions(context),
        );
      },
      child: AbsorbPointer(
        child: FormInputField(
          controller: _divisionCon,
          hintText: 'Pilih Divisi',
          labelText: 'Divisi',
          suffixIcon: LucideIcons.chevronDown,
          prefixIcon: LucideIcons.briefcase,
          isTriggerBottomSheet: true,
          required: true,
        ),
      ),
    );
  }

  Widget _divisions(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.w),
        width: double.infinity,
        child: BlocProvider(
          create: (context) => DisplayAllDivisionsCubit()..displayDivisions(),
          child: BlocBuilder<DisplayAllDivisionsCubit, DisplayAllDivisionsState>(
            builder: (context, state) {
              if (state is DisplayAllDivisionsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DisplayAllDivisionsLoaded) {
                final divisions = state.divisions;
                final isNotEmpty = divisions.isNotEmpty;

                if (isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Pilih Divisi",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.foreground),
                      ),
                      SizedBox(height: 16.h),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: divisions.length,
                        itemBuilder: (context, index) {
                          bool isSelected = _divisionCon.text == divisions[index].name;

                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            selected: isSelected,
                            selectedTileColor: AppColors.primary.withOpacity(0.1),
                            title: Row(
                              children: [
                                if (isSelected)
                                  const Icon(LucideIcons.check, color: AppColors.foreground)
                                else
                                  SizedBox(width: 24.w),
                                SizedBox(width: 8.w),
                                Text(
                                  divisions[index].name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            onTap: () {
                              _divisionCon.text = divisions[index].name;
                              divisionId = divisions[index].id;
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ],
                  );
                }
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context, User user) {
    return Builder(builder: (context) {
      return BasicReactiveButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<ButtonStateCubit>().execute(
                usecase: UpdateProfile(),
                params: UpdateUserReq(
                  id: user.id,
                  fullName: _fullNameCon.text,
                  username: _usernameCon.text,
                  newPhoto: _newPhoto,
                  divisionId: divisionId,
                ));
          }
        },
        title: "Simpan",
      );
    });
  }

  Widget _avatarField(BuildContext context, User user) {
    return Column(
      children: [
        if (_newPhoto == null) ...[
          UserAvatar(
            imageUrl: user.photo,
            name: user.fullName,
            size: UserAvatarSize.large,
          )
        ] else ...[
          UserAvatar(
            imageFile: _newPhoto,
            name: user.fullName,
            size: UserAvatarSize.large,
          )
        ],
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_newPhoto != null) ...[
              BasicAppButton(
                onPressed: () {
                  setState(() {
                    _newPhoto = null;
                  });
                },
                width: 100.w,
                variant: ButtonVariant.ghost,
                title: "Reset",
              ),
              SizedBox(width: 16.w),
            ],
            BasicAppButton(
              onPressed: selectImage,
              width: 100.w,
              variant: ButtonVariant.outline,
              title: "Ganti",
            ),
          ],
        )
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
      readOnly: true,
      required: true,
      description: "Email tidak dapat diubah",
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
}
