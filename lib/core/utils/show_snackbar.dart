import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

void showSnackBar(BuildContext context, String content, {String? dismissText}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        action: dismissText != null
            ? SnackBarAction(
                label: dismissText,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                textColor: AppPallete.primaryColor1,
              )
            : null,
      ),
    );
}
