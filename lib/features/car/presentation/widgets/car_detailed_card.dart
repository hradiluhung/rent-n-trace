import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/extension/string_extension.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/core/secrets/app_secrets.dart';

class CarDetailedCard extends StatelessWidget {
  final String carImage;
  final String carName;
  final String carFuelType;
  final String carFuelConsumption;

  const CarDetailedCard({
    super.key,
    required this.carImage,
    required this.carName,
    required this.carFuelType,
    required this.carFuelConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.darkBackground,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            ),
            child: SizedBox(
              width: 120.r,
              height: 80.h,
              child: Image.network(
                "${AppSecrets.supabaseUrl}$carImage",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mobil",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  carName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  "${carFuelType.capitalize()} - ($carFuelConsumption)",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
