import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/custom_shimmer_effect.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/booking_page.dart';

class CurrentMonthRentsCard extends StatelessWidget {
  final String currentMonthYear;
  final int totalRent;
  final String estimatedFuelCost;
  final String mostRentedCar;
  final String lastRentedDate;
  final bool isRentActive;

  const CurrentMonthRentsCard({
    super.key,
    this.currentMonthYear = "",
    this.totalRent = 0,
    this.estimatedFuelCost = "",
    this.mostRentedCar = "",
    this.lastRentedDate = "",
    this.isRentActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPalette.primaryColor4,
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: AppPalette.whiteColor,
              fontSize: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik $currentMonthYear',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppPalette.lightHeadlineTextColor,
                      ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppPalette.whiteColor,
                        width: 0.5.h,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah Pinjam',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppPalette.lightHeadlineTextColor,
                                    ),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                totalRent.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: AppPalette.whiteColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimasi Biaya Bensin',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppPalette.lightHeadlineTextColor,
                                    ),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                estimatedFuelCost,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppPalette.whiteColor,
                                    ),
                              ),
                              SizedBox(height: 14.sp),
                              Text(
                                'Paling Sering Dipinjam',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: AppPalette.lightHeadlineTextColor,
                                    ),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                mostRentedCar,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: isRentActive
                          ? Text("Anda sedang meminjam mobil",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppPalette.whiteColor,
                                    fontSize: 14.sp,
                                  ))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Terakhir Pinjam",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppPalette.whiteColor,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  lastRentedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppPalette.whiteColor,
                                        fontSize: 14.sp,
                                      ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryButton(
                          icon: EvaIcons.editOutline,
                          onPressed: () =>
                              Navigator.push(context, BookingPage.route()),
                          text: "Booking",
                          isDisabled: isRentActive,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonCurrRentCard extends StatelessWidget {
  const SkeletonCurrRentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CustomShimmerEffect(
      child: CurrentMonthRentsCard(),
    );
  }
}
