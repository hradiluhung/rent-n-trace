import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/common/helpers/utils/utils.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent_history.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_history_detail_page.dart';

class RentHistoryCard extends StatelessWidget {
  final RentHistory rentHistory;

  const RentHistoryCard({super.key, required this.rentHistory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, RentHistoryDetailPage(rentHistoryId: rentHistory.id));
      },
      child: Card(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  if (rentHistory.carImage != null)
                    Image.network(
                      rentHistory.carImage!,
                      width: 100.r,
                    ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rentHistory.carName ?? "-",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.foreground,
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "${rentHistory.rentStartDate!.toddMMMMyyyyShort()} - ${rentHistory.rentEndDate!.toddMMMMyyyyShort()}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: 4.h),
                        RichText(
                          text: TextSpan(
                            text: formatToRupiah(rentHistory.fuelCost),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                            children: [
                              TextSpan(
                                text: " - ${rentHistory.distance} KM",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
