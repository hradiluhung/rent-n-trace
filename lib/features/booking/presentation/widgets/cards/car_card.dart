import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/status_constants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/features/booking/domain/entities/car.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.w,
      decoration: BoxDecoration(
        color: AppPalette.primaryColor1,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (car.images.isNotEmpty && car.images[0] != null)
              Center(
                child: Image.network(
                  car.images[0]!,
                  height: 90.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppPalette.primaryColor4,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 1,
                  ),
                  Text(
                    CarStatus.getDescription(car.status),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPalette.bodyTextColor2,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
        color: AppPalette.transparentColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
