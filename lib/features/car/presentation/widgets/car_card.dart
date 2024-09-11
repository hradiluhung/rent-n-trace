import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/car/domain/entity/car.dart';
import 'package:rent_n_trace/features/car/presentation/pages/car_detail_page.dart';
import 'package:rent_n_trace/features/car/presentation/widgets/car_status_badge.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final bool selectable;
  final bool? selected;
  final Function(Car)? onSelect;

  const CarCard({
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
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    car.image,
                    height: 90.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h),
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
                      SizedBox(height: 4.h),
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
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    car.image,
                    height: 90.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h),
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
                      SizedBox(height: 4.h),
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

class CarCardSkeleton extends StatelessWidget {
  const CarCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
