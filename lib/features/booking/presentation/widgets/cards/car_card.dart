import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/statuses.dart';
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
        color: AppPallete.primaryColor4,
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
                          color: AppPallete.primaryColor3,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 1,
                  ),
                  Text(
                    CarStatus.getDescription(car.status),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPallete.bodyTextColor2,
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
