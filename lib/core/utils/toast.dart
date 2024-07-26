import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';

void showToast({
  required BuildContext context,
  required String message,
  int status = WidgetStatus.info,
}) {
  if (status == WidgetStatus.error) {
    CherryToast.error(
      title: Text(
        message,
      ),
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
    ).show(context);
    return;
  }

  if (status == WidgetStatus.success) {
    CherryToast.success(
      title: Text(
        message,
      ),
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
    ).show(context);
    return;
  }

  if (status == WidgetStatus.warning) {
    CherryToast.warning(
      title: Text(
        message,
      ),
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
    ).show(context);
    return;
  }

  CherryToast.info(
    title: Text(
      message,
    ),
    toastDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 500),
  ).show(context);
}
