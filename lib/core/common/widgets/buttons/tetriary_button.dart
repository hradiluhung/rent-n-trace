import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class TetriaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final int widgetSize;

  const TetriaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.widgetSize = WidgetSizes.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetSize == WidgetSizes.medium ? 40.h : 30.h,
      decoration: BoxDecoration(
        color: AppPalette.transparentColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: ElevatedButton.icon(
        icon: icon != null
            ? Icon(
                icon,
                color: AppPalette.bodyTextColor,
              )
            : null,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(isFullWidth ? 395.w : double.infinity,
              widgetSize == WidgetSizes.medium ? 40.h : 30.h),
          backgroundColor: AppPalette.transparentColor,
          shadowColor: AppPalette.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.buttonTetriary,
        ),
      ),
    );
  }
}
