import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';

enum AppSnackbarType { success, error, warning, info }

class AppSnackbar {
  static void show(BuildContext context, String message, AppSnackbarType type) {
    Color backgroundColor;
    switch (type) {
      case AppSnackbarType.success:
        backgroundColor = Colors.green;
        break;
      case AppSnackbarType.error:
        backgroundColor = AppColors.error;
        break;
      case AppSnackbarType.warning:
        backgroundColor = Colors.orange;
        break;
      case AppSnackbarType.info:
      default:
        backgroundColor = Colors.blue;
        break;
    }

    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
