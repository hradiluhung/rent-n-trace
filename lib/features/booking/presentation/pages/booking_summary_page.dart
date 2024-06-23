import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/constants/widget_status.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/utils/show_toast.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/home_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/dialogs/confirmation_dialog.dart';

class BookingSummaryPage extends StatefulWidget {
  static route(Rent rent) =>
      MaterialPageRoute(builder: (context) => BookingSummaryPage(rent: rent));

  final Rent rent;
  const BookingSummaryPage({super.key, required this.rent});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  // show confirmation dialog for cancel booking
  void _showCancelConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
              dismissText: "Tidak",
              confirmText: "Ya",
              title: "Konfirmasi",
              content: "Apakah anda yakin ingin membatalkan booking ini?",
              onConfirm: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context, HomePage.route(), (route) => false);
              },
              onDismiss: () {
                Navigator.pop(context);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ringkasan Booking',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: BlocConsumer<RentBloc, RentState>(
            listener: (context, state) {
              if (state is RentFailure) {
                showToast(
                  context: context,
                  title: state.message,
                  icon: EvaIcons.alertCircleOutline,
                  status: WidgetStatus.error,
                );
              }

              if (state is RentCreateRentSuccess) {
                showToast(
                  context: context,
                  title: 'Sukses melakukan booking',
                  icon: EvaIcons.checkmark,
                  status: WidgetStatus.success,
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  HomePage.route(),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is RentLoading) {
                return const Loader(loadingText: 'Melakukan booking');
              }
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppPallete.primaryColor4,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Booking',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: 24.h),
                          Center(
                            child: Image.network(
                              widget.rent.carImage!,
                              height: 120.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Nama Mobil',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPallete.bodyTextColor,
                                ),
                          ),
                          Text(
                            '${widget.rent.carName}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPallete.headlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Tanggal Booking',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPallete.bodyTextColor,
                                ),
                          ),
                          Text(
                            '${widget.rent.startDateTime.toFormattedddMMMMyyyy()} - ${widget.rent.endDateTime.toFormattedddMMMMyyyy()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPallete.headlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Tujuan',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPallete.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.destination,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPallete.headlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Kebutuhan',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPallete.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.need,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPallete.headlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Detail Kebutuhan',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPallete.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.needDetail,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPallete.headlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Supir',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPallete.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.driverName ?? '-',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPallete.headlineTextColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SecondaryButton(
                          isFullWidth: true,
                          text: "Batal",
                          onPressed: () {
                            _showCancelConfirmationDialog();
                          }),
                      SizedBox(height: 8.w),
                      PrimaryButton(
                        isFullWidth: true,
                        text: "Selesaikan",
                        onPressed: () {
                          context.read<RentBloc>().add(
                                RentCreateRent(
                                  userId: widget.rent.userId,
                                  startDate: widget.rent.startDateTime,
                                  endDate: widget.rent.endDateTime,
                                  destination: widget.rent.destination,
                                  need: widget.rent.need,
                                  needDetail: widget.rent.needDetail,
                                  driverId: widget.rent.driverId,
                                  driverName: widget.rent.driverName,
                                  carId: widget.rent.carId,
                                  carName: widget.rent.carName,
                                ),
                              );
                        },
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
