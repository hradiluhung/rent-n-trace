import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/user_avatar.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final String? driverPhoto;

  const DriverCard({super.key, required this.driverName, this.driverPhoto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatar(name: driverName, imageUrl: driverPhoto),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Supir",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondForeground,
                        fontSize: 14.sp,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  driverName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.foreground,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
