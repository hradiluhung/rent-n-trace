import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;
  final bool isFullWidth;
  final int widgetSize;
  final int widgetStatus;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.widgetSize = WidgetSizes.medium,
    this.widgetStatus = WidgetStatus.normal,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.rejectedColor.withOpacity(isDisabled ? 0.1 : 0.2);
        default:
          return AppPalette.greyColor.withOpacity(isDisabled ? 0.1 : 0.2);
      }
    }

    Color getBorderColor() {
      switch (widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.rejectedColor.withOpacity(0.4);
        default:
          return AppPalette.greyColor.withOpacity(0.4);
      }
    }

    Color getTextColor() {
      switch (widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.rejectedColor.withOpacity(isDisabled ? 0.3 : 1.0);
        default:
          return AppPalette.bodyTextColor.withOpacity(isDisabled ? 0.3 : 1.0);
      }
    }

    return Container(
      height: widgetSize == WidgetSizes.medium ? 40.h : 30.h,
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        border: Border.all(
          color: getBorderColor(),
          width: 0.8.w,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(isFullWidth ? 395.w : double.infinity,
              widgetSize == WidgetSizes.medium ? 40.h : 30.h),
          backgroundColor: AppPalette.transparentColor,
          shadowColor: AppPalette.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        icon: icon != null
            ? Icon(
                icon,
                color: getTextColor(),
                size: widgetSize == WidgetSizes.medium ? 20.r : 16.r,
              )
            : null,
        label: Text(
          text,
          style: Theme.of(context).textTheme.buttonSecondary.copyWith(
                color: getTextColor(),
              ),
        ),
      ),
    );
  }
}
