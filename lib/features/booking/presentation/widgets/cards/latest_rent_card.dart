import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/extensions/date_time_extension.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/features/booking/domain/entities/rent.dart';
import 'package:rent_n_trace/features/booking/presentation/pages/detail_rent_page.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/tags/rent_status_tags.dart';
import 'package:rent_n_trace/features/tracking/presentation/pages/tracking_page.dart';

class LatestRentCard extends StatelessWidget {
  final Rent rent;
  final void Function() onDismissed;
  const LatestRentCard(
      {super.key, required this.rent, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Booking Anda",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              if (rent.status == RentStatus.cancelled ||
                  rent.status == RentStatus.rejected)
                GestureDetector(
                  onTap: onDismissed,
                  child: const Icon(EvaIcons.close),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppPalette.whiteColor,
              boxShadow: [AppBoxShadow.myBoxShadow],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (rent.carImage != null)
                            Center(
                              child: Image.network(
                                rent.carImage!,
                                height: 72.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RentStatusTags(rentStatus: rent.status!),
                            SizedBox(height: 4.h),
                            Text(
                              rent.carName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              rent.destination,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${rent.startDateTime.toFormattedddMMMMyyyy()}-${rent.endDateTime.toFormattedddMMMMyyyy()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                  ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SecondaryButton(
                        icon: EvaIcons.infoOutline,
                        text: "Detail",
                        onPressed: () => {
                          Navigator.push(context, DetailRentPage.route(rent)),
                        },
                        widgetSize: WidgetSizes.small,
                      ),
                      // if (rent.status == RentStatus.approved) ...[
                      SizedBox(width: 8.w),
                      PrimaryButton(
                        icon: EvaIcons.playCircleOutline,
                        text: "Mulai",
                        onPressed: () {
                          Navigator.push(
                            context,
                            TrackingPage.route(rent.id!),
                          );
                        },
                        widgetSize: WidgetSizes.small,
                      ),
                      // ]
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
