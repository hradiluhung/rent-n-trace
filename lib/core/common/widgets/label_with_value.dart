import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

class LabelWithValue extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? content;

  const LabelWithValue({
    super.key,
    required this.label,
    this.value,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.foreground,
              ),
        ),
        SizedBox(height: 4.h),
        if (content != null && value == null)
          content!
        else
          Text(value!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondForeground,
                  )),
      ],
    );
  }
}
