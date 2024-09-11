import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/extension/date_time_extension.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/rent/domain/entities/rent.dart';
import 'package:rent_n_trace/features/rent/presentation/pages/rent_detail_page.dart';
import 'package:rent_n_trace/features/rent/presentation/widgets/rent_status_badge.dart';

class LatestRentCard extends StatelessWidget {
  final Rent latestRent;
  const LatestRentCard({super.key, required this.latestRent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pinjaman Terakhir',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.foreground,
                ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, RentDetailPage(id: latestRent.id));
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
                        if (latestRent.carImage != null)
                          Image.network(
                            latestRent.carImage!,
                            width: 100.r,
                          ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                latestRent.carName ?? "-",
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.foreground,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Text(
                                "${latestRent.startDate.toddMMMMyyyy()} - ${latestRent.endDate.toddMMMMyyyy()}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: 8.h),
                              RentStatusBadge(rentStatus: latestRent.status)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
