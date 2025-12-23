import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/models/date_range_req.dart';
import 'package:rent_n_trace/core/common/models/rent_creation_req.dart';
import 'package:rent_n_trace/core/common/widgets/app_alert.dart';
import 'package:rent_n_trace/core/common/widgets/app_bottom_sheet.dart';
import 'package:rent_n_trace/core/common/widgets/app_checkbox.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_date_picker_range_field.dart';
import 'package:rent_n_trace/core/common/widgets/form/form_input_field.dart';
import 'package:rent_n_trace/core/config/assets/app_images.dart';
import 'package:rent_n_trace/core/config/assets/app_json.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_available_drivers_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_available_drivers_state.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_choose_car_page.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_cubit.dart';
import 'package:rent_n_trace/features/splash/presentation/bloc/user_state.dart';

class RentCreatePage extends StatefulWidget {
  final String? rejectMessage;
  const RentCreatePage({super.key, this.rejectMessage});

  @override
  State<RentCreatePage> createState() => _RentCreatePageState();
}

class _RentCreatePageState extends State<RentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _destinationCon = TextEditingController();
  final TextEditingController _dateRangeCon = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController _needCon = TextEditingController();
  final TextEditingController _detailNeedCon = TextEditingController();
  bool _needDriver = false;
  final TextEditingController _driverCon = TextEditingController();
  String? driverId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Buat Sewa",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 20.sp,
                color: AppColors.foreground,
              ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final user = (state as UserAuthenticated).user;

          if (user.divisionName != null) {
            return Container(
              padding: EdgeInsets.all(16.r),
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserAuthenticated) {
                    return BasicAppButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final rent = RentCreationReq(
                            startDate: startDate!,
                            endDate: endDate!,
                            destination: _destinationCon.text,
                            need: _needCon.text,
                            needDetail: _detailNeedCon.text,
                            driverId: driverId,
                            userId: state.user.id,
                          );

                          AppNavigator.push(
                              context, RentChooseCarPage(rent: rent));
                        }
                      },
                      title: "Pilih Mobil",
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final user = (state as UserAuthenticated).user;

          return user.divisionName != null
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.rejectMessage != null) ...[
                          AppAlert(
                            icon: LucideIcons.alertCircle,
                            message:
                                "Sesuaikan dengan alasan penolakan: ${widget.rejectMessage!}",
                            variant: AppAlertVariant.warning,
                          ),
                          SizedBox(height: 20.h),
                        ],
                        _dateRangeField(),
                        SizedBox(height: 20.h),
                        _destinationField(),
                        SizedBox(height: 20.h),
                        _selectNeedField(context),
                        SizedBox(height: 20.h),
                        _detailNeedField(),
                        SizedBox(height: 20.h),
                        _needDriverField(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Lottie.asset(
                          AppJson.alert,
                          height: 120.h,
                        ),
                        const Text(
                          "Tidak bisa booking. Lengkapi data divisi di profil Anda terlebih dahulu.",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        BasicAppButton(
                          variant: ButtonVariant.outline,
                          title: "Lengkapi",
                          onPressed: () {
                            AppNavigator.push(
                                context,
                                const LandingPage(
                                  defaultIndex: 3,
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _needDriverField() {
    return Column(
      children: [
        AppCheckbox(
          value: _needDriver,
          onValueChanged: (value) {
            if (value == false) {
              _driverCon.clear();
              driverId = null;
            }

            setState(() {
              _needDriver = value!;
            });
          },
          label: "Butuh Sopir",
        ),
        SizedBox(height: 20.h),
        if (_needDriver) _driverField(context),
      ],
    );
  }

  Widget _driverField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (startDate == null || endDate == null) {
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: const Text('Pilih waktu peminjaman terlebih dahulu'),
            backgroundColor: AppColors.alert,
            contentTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
            actions: [
              TextButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ));
          return;
        }

        AppBottomSheet.display(
          context,
          _drivers(context),
        );
      },
      child: AbsorbPointer(
        child: FormInputField(
          controller: _driverCon,
          hintText: 'Pilih Driver',
          labelText: 'Driver',
          suffixIcon: LucideIcons.chevronDown,
          prefixIcon: LucideIcons.user,
          isTriggerBottomSheet: true,
          required: _needDriver ? true : false,
        ),
      ),
    );
  }

  Widget _drivers(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.w),
        width: double.infinity,
        child: BlocProvider(
          create: (context) => DisplayAvailableDriversCubit()
            ..displayDrivers(
              DateRangeReq(startDate: startDate!, endDate: endDate!),
            ),
          child: BlocBuilder<DisplayAvailableDriversCubit,
              DisplayAvailableDriversState>(
            builder: (context, state) {
              if (state is DisplayDriversLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DisplayDriversLoaded) {
                final drivers = state.drivers;
                final isNotEmpty = state.drivers.isNotEmpty;

                if (isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Pilih Driver",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.foreground),
                      ),
                      SizedBox(height: 16.h),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: drivers.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              _driverCon.text == drivers[index].name;

                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            selected: isSelected,
                            selectedTileColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            title: Row(
                              children: [
                                if (isSelected)
                                  const Icon(LucideIcons.check,
                                      color: AppColors.foreground)
                                else
                                  SizedBox(width: 24.w),
                                SizedBox(width: 8.w),
                                Text(
                                  drivers[index].name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            onTap: () {
                              _driverCon.text = drivers[index].name;
                              driverId = drivers[index].id;
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ],
                  );
                }

                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Image.asset(
                        AppImages.emptyData,
                        height: 100.h,
                      ),
                      SizedBox(height: 16.h),
                      const Text(
                        "Tidak ada driver tersedia. Coba pilih tanggal lain atau hubungi admin",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _detailNeedField() {
    return FormInputField(
      controller: _detailNeedCon,
      hintText: 'Jelaskan keperluan Anda',
      labelText: 'Detail Keperluan',
      maxLines: 5,
      required: true,
    );
  }

  Widget _dateRangeField() {
    return FormDatePickerRangeField(
      prefixIcon: LucideIcons.calendar,
      labelText: "Waktu Peminjaman",
      controller: _dateRangeCon,
      hintText: "Waktu Peminjaman",
      required: true,
      validator: (value) {
        if (startDate == null || endDate == null) {
          return 'Tanggal mulai dan akhir harus diisi';
        }
        return null;
      },
      onDateSelected: (dateRange) {
        if (dateRange != null) {
          setState(() {
            startDate = dateRange.startDate;
            endDate = dateRange.endDate;
          });
        }
      },
    );
  }

  Widget _destinationField() {
    return FormInputField(
      controller: _destinationCon,
      hintText: '(Kecamatan), (Kota/Kabupaten)',
      labelText: 'Tujuan',
      prefixIcon: LucideIcons.map,
      required: true,
    );
  }

  Widget _selectNeedField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomSheet.display(
          context,
          _needs(context),
        );
      },
      child: AbsorbPointer(
        child: FormInputField(
          controller: _needCon,
          hintText: 'Pilih Kebutuhan',
          labelText: 'Kebutuhan',
          suffixIcon: LucideIcons.chevronDown,
          prefixIcon: LucideIcons.listChecks,
          isTriggerBottomSheet: true,
          required: true,
        ),
      ),
    );
  }

  List<String> needs = ["Pondok", "Pribadi"];
  Widget _needs(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Pilih Kebutuhan",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.foreground),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            itemCount: needs.length,
            itemBuilder: (context, index) {
              bool isSelected = _needCon.text == needs[index];
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
                      needs[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                onTap: () {
                  _needCon.text = needs[index];

                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
