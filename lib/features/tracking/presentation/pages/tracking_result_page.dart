import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:realm/realm.dart';
import 'package:rent_n_trace/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:rent_n_trace/core/common/realm/realm_config.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/inputs/form_input_field.dart';
import 'package:rent_n_trace/core/common/widgets/layouts/user_layout.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/tracking/data/models/realm/local_locations.dart';
import 'package:rent_n_trace/features/tracking/presentation/bloc/rent/tracking_rent_bloc.dart';

class TrackingResultPage extends StatefulWidget {
  static route(String rentId) =>
      MaterialPageRoute(builder: (context) => TrackingResultPage(rentId: rentId));

  final String rentId;
  const TrackingResultPage({super.key, required this.rentId});

  @override
  State<TrackingResultPage> createState() => _TrackingResultPageState();
}

class _TrackingResultPageState extends State<TrackingResultPage>
    with SingleTickerProviderStateMixin {
  Realm realm = RealmConfig().getRealm();
  late AnimationController _animationController;
  late Animation<double> _fadeInUpAnimation;

  bool isEditFuelConsumption = false;
  final _fuelConsumptionTextController = TextEditingController();
  double distance = 0;

  @override
  void initState() {
    super.initState();

    context.read<TrackingRentBloc>().add(TrackingRentGetByRentIdEvent(widget.rentId));

    final locationData = realm.all<LocalLocations>();
    if (locationData.isNotEmpty) {
      setState(() {
        distance = locationData.first.distance;
      });
    }

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInUpAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _animationController.forward();
    clearLocalLocations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fuelConsumptionTextController.dispose();
    super.dispose();
  }

  clearLocalLocations() async {
    await Future.delayed(const Duration(seconds: 3));
    realm.write(() {
      realm.deleteAll<LocalLocations>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrackingRentBloc, TrackingRentState>(
        builder: (context, state) {
          if (state is TrackingRentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrackingRentGetSuccess) {
            final rent = state.rent;

            return FadeTransition(
              opacity: _animationController,
              child: Transform.translate(
                offset: Offset(0, _fadeInUpAnimation.value),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          EvaIcons.checkmarkCircle2Outline,
                          size: 100,
                          color: AppPalette.primaryColor2,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Tracking Selesai",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Jarak perjalanan: ${distance.toStringAsFixed(2)} meter",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Estimasi biaya bensin: ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: ' Rp. ${rent.fuelConsumption}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ]),
                        ),
                        SizedBox(height: 48.h),
                        if (!isEditFuelConsumption) ...[
                          Column(
                            children: [
                              Text(
                                "Apakah estimasi biaya bensin sesuai?",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SecondaryButton(
                                    onPressed: () {
                                      _fuelConsumptionTextController.text =
                                          rent.fuelConsumption.toString();
                                      setState(() {
                                        isEditFuelConsumption = true;
                                      });
                                    },
                                    text: "Tidak",
                                  ),
                                  SizedBox(width: 16.w),
                                  PrimaryButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        UserLayout.route(),
                                        (route) => false,
                                      );
                                    },
                                    text: "Ya",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ] else ...[
                          FormInputField(
                            controller: _fuelConsumptionTextController,
                            hintText: "Biaya bensin (Rp)",
                            keyboardType: TextInputType.number,
                            labelText: "Biaya bensin (Rp)",
                            prefixIcon: Icons.money_outlined,
                            isRequired: true,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          BlocConsumer<TrackingRentBloc, TrackingRentState>(
                            listener: (context, state) {
                              if (state is TrackingRentUpdateSuccess) {
                                showToast(
                                  context: context,
                                  message: "Berhasil menyimpan biaya bensin",
                                  status: WidgetStatus.success,
                                );

                                final authData =
                                    context.read<AppUserCubit>().state as AppUserLoggedIn;
                                context
                                    .read<RentBloc>()
                                    .add(RentGetAllStatsRent(userId: authData.user.id));

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  UserLayout.route(),
                                  (route) => false,
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is TrackingRentLoading;

                              return PrimaryButton(
                                onPressed: () {
                                  context.read<TrackingRentBloc>().add(TrackingRentUpdateFuelEvent(
                                      rent.id!, int.parse(_fuelConsumptionTextController.text)));
                                },
                                text: "Simpan",
                                isFullWidth: true,
                                isLoading: isLoading,
                                isDisabled: isLoading,
                              );
                            },
                          ),
                        ]
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
