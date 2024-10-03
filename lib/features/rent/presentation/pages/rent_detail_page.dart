import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state.dart';
import 'package:rent_n_trace/core/common/bloc/button/button_state_cubit.dart';
import 'package:rent_n_trace/core/common/constants/rent_status.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/widgets/app_snackbar.dart';
import 'package:rent_n_trace/core/common/widgets/basic_appbar.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_app_button.dart';
import 'package:rent_n_trace/core/common/widgets/button/basic_reactive_button.dart';
import 'package:rent_n_trace/core/common/widgets/label_with_value.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_detailed_card.dart';
import 'package:rent_n_trace/features/driver/presentation/widgets/driver_card.dart';
import 'package:rent_n_trace/features/home/presentation/bloc/display_rent_stats_cubit.dart';
import 'package:rent_n_trace/features/home/presentation/pages/landing_page.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/rent/domain/usecases/rent/cancel_rent.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_cubit.dart';
import 'package:rent_n_trace/features/rent/presentation/bloc/display_detail_rent_state.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_create_page.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_status_badge.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_page.dart';

class RentDetailPage extends StatefulWidget {
  final String rentId;
  const RentDetailPage({super.key, required this.rentId});

  @override
  State<RentDetailPage> createState() => _RentDetailPageState();
}

class _RentDetailPageState extends State<RentDetailPage> {
  late BuildContext mainContext;

  @override
  void initState() {
    super.initState();
    mainContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DisplayDetailRentCubit()..displayDetailRent(widget.rentId),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Detail Peminjaman",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.foreground,
                ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16.r),
          child: BlocBuilder<DisplayDetailRentCubit, DisplayDetailRentState>(
            builder: (context, state) {
              if (state is DisplayDetailRentLoaded) {
                final status = state.rent.status;
                final isRentToday = state.rent.startDate.isSameDate(DateTime.now());

                if (status == RentStatus.approved || status == RentStatus.tracked) {
                  return BasicAppButton(
                    onPressed: () {
                      AppNavigator.push(
                        context,
                        MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: mainContext.read<DislayRentStatsCubit>()),
                            BlocProvider.value(value: context.read<DisplayDetailRentCubit>()),
                          ],
                          child: TrackingPage(rent: state.rent),
                        ),
                      );
                    },
                    title: isRentToday
                        ? status == RentStatus.approved
                            ? "Mulai Perjalanan"
                            : "Lacak Lokasi"
                        : '',
                    content: !isRentToday
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                LucideIcons.info,
                              ),
                              SizedBox(width: 8.w),
                              const Text(
                                "Menunggu Jadwal Pinjam",
                              ),
                            ],
                          )
                        : null,
                    disabled: !isRentToday,
                  );
                }

                if (status == RentStatus.rejected) {
                  return BasicAppButton(
                    title: 'Ajukan Lagi',
                    onPressed: () {
                      AppNavigator.push(
                          context,
                          RentCreatePage(
                            rejectMessage: state.rent.rejectMessage,
                          ));
                    },
                  );
                }

                if (status == RentStatus.pending) {
                  return BlocListener<ButtonStateCubit, ButtonState>(
                    listener: (context, state) {
                      if (state is ButtonFailure) {
                        AppSnackbar.show(context, state.message, AppSnackbarType.error);
                      }

                      if (state is ButtonSuccess) {
                        final message = state.data as String;
                        AppSnackbar.show(context, message, AppSnackbarType.success);
                        AppNavigator.pushAndRemove(context, const LandingPage());
                      }
                    },
                    child: Builder(builder: (context) {
                      return BasicReactiveButton(
                        variant: ButtonVariant.outline,
                        onPressed: () {
                          context
                              .read<ButtonStateCubit>()
                              .execute(usecase: CancelRent(), params: widget.rentId);
                        },
                        title: "Batalkan Peminjaman",
                      );
                    }),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        body: BlocBuilder<DisplayDetailRentCubit, DisplayDetailRentState>(
          builder: (context, state) {
            if (state is DisplayDetailRentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DisplayDetailRentLoaded) {
              final rent = state.rent;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarDetailedCard(
                        carImage: rent.carImage!,
                        carName: rent.carName!,
                        carFuelType: rent.carFuelType!,
                        carFuelConsumption: rent.carFuelConsumption!,
                      ),
                      if (rent.driverId != null) ...[
                        SizedBox(height: 16.h),
                        DriverCard(driverName: rent.driverName!, driverPhoto: rent.driverPhoto)
                      ],
                      SizedBox(height: 16.h),
                      _otherDetail(context, rent),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _otherDetail(BuildContext context, Rent rent) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelWithValue(
            label: "Tanggal Peminjaman",
            value: "${rent.startDate.toddMMMMyyyy()} - ${rent.endDate.toddMMMMyyyy()}",
          ),
          SizedBox(height: 20.h),
          LabelWithValue(
            label: "Kebutuhan",
            value: rent.need,
          ),
          SizedBox(height: 20.h),
          LabelWithValue(
            label: "Detail Kebutuhan",
            value: rent.needDetail,
          ),
          SizedBox(height: 20.h),
          LabelWithValue(
            label: "Tujuan",
            value: rent.destination,
          ),
          SizedBox(height: 20.h),
          LabelWithValue(
            label: "Status",
            content: RentStatusBadge(rentStatus: rent.status),
          ),
          if (rent.rejectMessage != null) ...[
            SizedBox(height: 20.h),
            LabelWithValue(
              label: "Alasan ditolak",
              value: rent.rejectMessage,
            )
          ]
        ],
      ),
    );
  }
}
