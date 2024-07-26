import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/entities/user.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/common/widgets/layouts/user_layout.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/color_converter.dart';
import 'package:rent_n_trace/core/utils/image_picker.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  static route(User user) =>
      MaterialPageRoute(builder: (context) => ProfileEditPage(user: user));

  final User user;
  const ProfileEditPage({super.key, required this.user});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _divisionController = TextEditingController();
  File? _photo;

  @override
  void initState() {
    super.initState();
    _fullnameController.text = widget.user.fullName;
    _emailController.text = widget.user.email;
    _divisionController.text = widget.user.division ?? "";
  }

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _photo = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          showToast(
            context: context,
            message: "Profil berhasil diperbarui",
            status: WidgetStatus.success,
          );
          Navigator.pushAndRemoveUntil(
              context, UserLayout.route(defaultIndex: 1), (route) => false);
        }

        if (state is ProfileFailure) {
          showToast(
            context: context,
            message: state.message,
            status: WidgetStatus.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profil',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _photo != null
                      ? Column(children: [
                          SizedBox(
                            child: ClipOval(
                              child: Image.file(
                                _photo!,
                                width: 128.r,
                                height: 128.r,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SecondaryButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: EvaIcons.editOutline,
                                text: "Edit",
                                widgetSize: WidgetSizes.small,
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _photo = null;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8.r),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        strokeAlign: 1,
                                        color: AppPalette.errorColor
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.w),
                                  height: 30.h,
                                  child: const Icon(
                                    EvaIcons.trash2Outline,
                                    color: AppPalette.errorColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ])
                      : Column(
                          children: [
                            SizedBox(
                              child: ClipOval(
                                child: Image.network(
                                  widget.user.photo ??
                                      "https://ui-avatars.com/api/?name=${widget.user.fullName}&background=${colorToHex(AppPalette.primaryColor4)}&color=fff&size=256",
                                  width: 128.r,
                                  height: 128.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SecondaryButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: EvaIcons.editOutline,
                              text: "Edit",
                              widgetSize: WidgetSizes.small,
                            ),
                          ],
                        ),
                  SizedBox(height: 16.h),
                  FormInputField(
                    controller: _emailController,
                    hintText: "johndoe@gmail.com",
                    labelText: "Email",
                    isRequired: true,
                    prefixIcon: EvaIcons.emailOutline,
                    isDisabled: true,
                  ),
                  SizedBox(height: 16.h),
                  FormInputField(
                    controller: _fullnameController,
                    hintText: "John Doe",
                    labelText: "Nama Lengkap",
                    isRequired: true,
                    prefixIcon: EvaIcons.peopleOutline,
                  ),
                  SizedBox(height: 16.h),
                  FormInputField(
                    controller: _divisionController,
                    hintText: "Contoh: Sekretaris Pimpinan",
                    labelText: "Divisi/Kamar",
                    prefixIcon: EvaIcons.briefcaseOutline,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 16.h),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      final isLoading = state is ProfileLoading;

                      return PrimaryButton(
                        text: "Simpan",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final user = User(
                              id: widget.user.id,
                              email: _emailController.text,
                              fullName: _fullnameController.text,
                              division: _divisionController.text,
                              photo: widget.user.photo,
                            );
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfileEvent(user, _photo),
                                );
                          }
                        },
                        isLoading: isLoading,
                        isDisabled: isLoading,
                        icon: EvaIcons.checkmark,
                        isFullWidth: true,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
