import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';

class ReloadButton extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  const ReloadButton(
      {super.key, required this.message, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 8.h),
        SecondaryButton(
          text: "Muat Ulang",
          onPressed: onPressed,
          icon: EvaIcons.refreshOutline,
          widgetSize: WidgetSizes.small,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
