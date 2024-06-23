import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/widget_sizes.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;
  final bool isFullWidth;
  final int widgetSize;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.widgetSize = WidgetSizes.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetSize == WidgetSizes.medium ? 36.h : 30.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppPallete.primaryColor1.withOpacity(isDisabled ? 0.4 : 1.0),
            AppPallete.primaryColor2.withOpacity(isDisabled ? 0.4 : 1.0),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(isFullWidth ? 395.w : double.infinity,
              widgetSize == WidgetSizes.medium ? 36.h : 30.h),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        icon: icon != null
            ? Icon(
                icon,
                color:
                    AppPallete.whiteColor.withOpacity(isDisabled ? 0.5 : 1.0),
              )
            : null,
        label: Text(
          text,
          style: Theme.of(context).textTheme.buttonPrimary.copyWith(
                color:
                    AppPallete.whiteColor.withOpacity(isDisabled ? 0.5 : 1.0),
              ),
        ),
      ),
    );
  }
}
