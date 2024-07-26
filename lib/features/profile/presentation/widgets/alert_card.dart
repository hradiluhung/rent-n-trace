import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final int widgetStatus;
  final String buttonText;
  final VoidCallback onButtonClicked;

  const AlertCard({
    super.key,
    this.icon = EvaIcons.infoOutline,
    required this.title,
    required this.message,
    this.widgetStatus = WidgetStatus.warning,
    required this.buttonText,
    required this.onButtonClicked,
  });

  Color _getBackgrundColor() {
    switch (widgetStatus) {
      case WidgetStatus.warning:
        return AppPalette.warningColor.withOpacity(0.2);

      default:
        return AppPalette.primaryColor2.withOpacity(0.2);
    }
  }

  Color _getBorderColor() {
    switch (widgetStatus) {
      case WidgetStatus.warning:
        return AppPalette.warningColor.withOpacity(0.4);

      default:
        return AppPalette.primaryColor2.withOpacity(0.4);
    }
  }

  Color _getTextColor() {
    switch (widgetStatus) {
      case WidgetStatus.warning:
        return AppPalette.warningColor;

      default:
        return AppPalette.primaryColor2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: _getBackgrundColor(),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _getBorderColor(),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: _getTextColor(),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
                SizedBox(height: 2.h),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
                SizedBox(height: 12.h),
                SecondaryButton(
                  text: buttonText,
                  onPressed: onButtonClicked,
                  widgetSize: WidgetSizes.small,
                  widgetStatus: widgetStatus,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
