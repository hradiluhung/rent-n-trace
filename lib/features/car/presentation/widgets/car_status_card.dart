import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/pages/car_detail_page.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_status_badge.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CarStatusCard extends StatelessWidget {
  final Car car;
  final bool selectable;
  final bool? selected;
  final Function(Car)? onSelect;

  const CarStatusCard({
    super.key,
    required this.car,
    this.selectable = false,
    this.selected,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (selectable == false) {
      return GestureDetector(
        onTap: () {
          AppNavigator.push(context, CarDetailPage(id: car.id));
        },
        child: Container(
          width: 164.w,
          decoration: BoxDecoration(
            color: AppColors.secondBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Skeleton.replace(
                    replacement: Container(
                      width: double.infinity,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: AppColors.darkBackground.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Image.network(
                      car.image,
                      height: 90.h,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.foreground,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 1,
                      ),
                      SizedBox(height: 8.h),
                      CarStatusBadge(carStatus: car.status),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          onSelect?.call(car);
        },
        child: Container(
          width: 164.w,
          decoration: BoxDecoration(
            color: selected == true ? AppColors.darkBackground : AppColors.secondBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    car.image,
                    height: 90.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: selected == true ? Colors.white : AppColors.foreground,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 1,
                      ),
                      SizedBox(height: 8.h),
                      CarStatusBadge(carStatus: car.status),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
