import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

void showToast({
  required BuildContext context,
  required String message,
  IconData? icon,
  int status = WidgetStatus.info,
}) {
  if (status == WidgetStatus.error) {
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => ToastCard(
        leading: const Icon(
          EvaIcons.activity,
          size: 28,
          color: AppPalette.whiteColor,
        ),
        color: AppPalette.errorColor,
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppPalette.whiteColor,
          ),
        ),
      ),
    ).show(context);
  }
  if (status == WidgetStatus.normal) {
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => ToastCard(
        leading: const Icon(
          EvaIcons.activity,
          size: 28,
        ),
        color: AppPalette.primaryColor2,
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }
}
