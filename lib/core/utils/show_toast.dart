import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/constants/widget_status.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  required String title,
  required IconData icon,
  int status = WidgetStatus.info,
  int duration = 2,
}) {
  toastification.show(
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium,
    ),
    autoCloseDuration: Duration(seconds: duration),
    style: ToastificationStyle.flatColored,
    backgroundColor: () {
      if (status == WidgetStatus.success) {
        return AppPallete.primaryColor4;
      } else if (status == WidgetStatus.error) {
        return AppPallete.errorSurfaceColor;
      } else {
        return AppPallete.backgroundColor;
      }
    }(),
    primaryColor: () {
      if (status == WidgetStatus.success) {
        return AppPallete.primaryColor1;
      } else if (status == WidgetStatus.error) {
        return AppPallete.errorColor;
      } else {
        return AppPallete.headlineTextColor;
      }
    }(),
    foregroundColor: AppPallete.headlineTextColor,
    icon: Icon(icon),
    animationBuilder: (context, animation, alignment, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
