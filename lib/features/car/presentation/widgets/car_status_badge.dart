import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/constants/car_status.dart';

class CarStatusBadge extends StatelessWidget {
  final String carStatus;
  const CarStatusBadge({super.key, required this.carStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: CarStatus.getBackgroundColor(carStatus),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        CarStatus.getDescription(carStatus),
        style: TextStyle(
          color: CarStatus.getTextColor(carStatus),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
