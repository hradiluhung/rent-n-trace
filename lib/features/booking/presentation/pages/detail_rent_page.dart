import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/custom_back_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/home_page.dart';
import 'package:rent_n_trace/core/utils/confirmation_dialog.dart';

class DetailRentPage extends StatefulWidget {
  static route(Rent rent) =>
      MaterialPageRoute(builder: (context) => DetailRentPage(rent: rent));

  final Rent rent;
  const DetailRentPage({super.key, required this.rent});

  @override
  State<DetailRentPage> createState() => _DetailRentPageState();
}

class _DetailRentPageState extends State<DetailRentPage> {
  void _showCancelRentDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        dismissText: "Tidak",
        confirmText: "Ya",
        title: "Konfirmasi",
        content: "Apakah anda yakin ingin membatalkan booking ini?",
        onConfirm: () {
          context
              .read<RentBloc>()
              .add(RentUpdateCancelRent(rentId: widget.rent.id!));
          Navigator.pop(context);
        },
        onDismiss: () {
          Navigator.pop(context);
        },
        confirmStatus: WidgetStatus.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: BlocConsumer<RentBloc, RentState>(
          listener: (context, state) {
            if (state is RentUpdateRentSuccess) {
              showToast(
                context: context,
                message: state.message,
                status: WidgetStatus.success,
              );

              Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (route) => false,
              );
            }
            if (state is RentFailure) {
              showToast(
                context: context,
                message: state.message,
                status: WidgetStatus.error,
              );
            }
          },
          builder: (context, state) {
            if (state is RentLoading) {
              return const Center(
                child: Loader(loadingText: "Membatalkan"),
              );
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppPalette.primaryColor4,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.r),
                              bottomRight: Radius.circular(16.r),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 36.h, bottom: 32.h, right: 16.w, left: 16.w),
                          child: Column(
                            children: [
                              Text(
                                "Detail Booking",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: AppPalette.whiteColor,
                                    ),
                              ),
                              SizedBox(height: 16.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 64.r),
                                child: Image.network(
                                  widget.rent.carImage!,
                                ),
                              ),
                              Text(
                                widget.rent.carName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppPalette.whiteColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppPalette.bodyTextColor2,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        Text(
                                          "${widget.rent.startDateTime.toFormattedddMMMMyyyy()}- \n${widget.rent.endDateTime.toFormattedddMMMMyyyy()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppPalette.primaryColor4,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Durasi",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppPalette.bodyTextColor2,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        Text(
                                          "${widget.rent.endDateTime.difference(widget.rent.startDateTime).inDays} Hari",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppPalette.primaryColor4,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Kebutuhan",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppPalette.bodyTextColor2,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        Text(
                                          widget.rent.need,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppPalette.primaryColor4,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Detail Kebutuhan",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppPalette.bodyTextColor2,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        Text(
                                          widget.rent.needDetail,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppPalette.primaryColor4,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppPalette.bodyTextColor2,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        Text(
                                          RentStatus.getDescription(
                                              widget.rent.status),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: RentStatus.getColor(
                                                    widget.rent.status),
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Supir",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppPalette.bodyTextColor2,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        Text(
                                          widget.rent.driverName ?? "-",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: AppPalette.primaryColor4,
                                                fontSize: 16.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 32.h),
                    child: const CustomBackButton(
                      isOverDarkBackground: true,
                    ),
                  ),
                ),
                if (widget.rent.status == RentStatus.pending)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: SecondaryButton(
                        text: "Batalkan",
                        onPressed: _showCancelRentDialog,
                        isFullWidth: true,
                        widgetStatus: WidgetStatus.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
