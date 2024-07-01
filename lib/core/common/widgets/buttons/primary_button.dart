import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;
  final bool isFullWidth;
  final int widgetSize;
  final int widgetStatus;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.widgetSize = WidgetSizes.medium,
    this.widgetStatus = WidgetStatus.normal,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.errorColor.withOpacity(isDisabled ? 0.4 : 1.0);
        default:
          return AppPalette.primaryColor2.withOpacity(isDisabled ? 0.4 : 1.0);
      }
    }

    return Container(
      height: widgetSize == WidgetSizes.medium ? 40.h : 30.h,
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(
            isFullWidth ? 395.w : double.infinity,
            widgetSize == WidgetSizes.medium ? 40.h : 30.h,
          ),
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
                color:
                    AppPalette.whiteColor.withOpacity(isDisabled ? 0.5 : 1.0),
              )
            : null,
        label: Text(
          text,
          style: Theme.of(context).textTheme.buttonPrimary.copyWith(
                color:
                    AppPalette.whiteColor.withOpacity(isDisabled ? 0.5 : 1.0),
              ),
        ),
      ),
    );
  }
}
