import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/common/widgets/layouts/user_layout.dart';
import 'package:rent_n_trace/core/common/widgets/loader.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/services/local_storage_service.dart';
import 'package:rent_n_trace/core/utils/toast.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/bloc/rent/rent_bloc.dart';
import 'package:rent_n_trace/core/utils/confirmation_dialog.dart';

class BookingSummaryPage extends StatefulWidget {
  static route(Rent rent) => MaterialPageRoute(builder: (context) => BookingSummaryPage(rent: rent));

  final Rent rent;
  const BookingSummaryPage({super.key, required this.rent});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  late LocalStorageService _localStorageService;

  @override
  void initState() {
    super.initState();
    _localStorageService = LocalStorageService();
  }

  void _showLatestRentCardVisibility() async {
    await _localStorageService.setHideLatestRentCard(false);
  }

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
          Navigator.pushAndRemoveUntil(context, UserLayout.route(), (route) => false);
        },
        onDismiss: () {
          Navigator.pop(context);
        },
      ),
    );
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
                  message: state.message,
                  status: WidgetStatus.error,
                );
              }

              if (state is RentCreateRentSuccess) {
                showToast(
                  context: context,
                  message: 'Sukses melakukan booking',
                  status: WidgetStatus.success,
                );
                _showLatestRentCardVisibility();
                Navigator.pushAndRemoveUntil(
                  context,
                  UserLayout.route(),
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
                      color: AppPalette.primaryColor1,
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
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppPalette.bodyTextColor,
                                ),
                          ),
                          Text(
                            '${widget.rent.carName}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppPalette.darkHeadlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Tanggal Booking',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppPalette.bodyTextColor,
                                ),
                          ),
                          Text(
                            '${widget.rent.startDateTime.toFormattedddMMMMyyyy()} - ${widget.rent.endDateTime.toFormattedddMMMMyyyy()}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppPalette.darkHeadlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Tujuan',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppPalette.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.destination,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppPalette.darkHeadlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Kebutuhan',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppPalette.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.need,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppPalette.darkHeadlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Detail Kebutuhan',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppPalette.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.needDetail,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppPalette.darkHeadlineTextColor,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Supir',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppPalette.bodyTextColor,
                                ),
                          ),
                          Text(
                            widget.rent.driverName ?? "-",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppPalette.darkHeadlineTextColor,
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
