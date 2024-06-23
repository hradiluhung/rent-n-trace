import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/statuses.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class RentStatusTags extends StatelessWidget {
  final String rentStatus;
  const RentStatusTags({super.key, required this.rentStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: RentStatus.getColor(rentStatus),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        RentStatus.getDescription(rentStatus),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: rentStatus == RentStatus.approved
                  ? AppPallete.headlineTextColor
                  : AppPallete.whiteColor,
              fontSize: 10.sp,
            ),
      ),
    );
  }
}
