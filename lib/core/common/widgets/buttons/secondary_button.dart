import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:rent_n_trace/core/theme/theme.dart';

class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;
  final bool isFullWidth;
  final int widgetSize;
  final int widgetStatus;
  final bool isLoading;

  const SecondaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.icon,
      this.isFullWidth = false,
      this.isDisabled = false,
      this.widgetSize = WidgetSizes.medium,
      this.widgetStatus = WidgetStatus.normal,
      this.isLoading = false});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      switch (widget.widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.rejectedColor
              .withOpacity(widget.isDisabled ? 0.1 : 0.2);
        case WidgetStatus.warning:
          return AppPalette.warningColor
              .withOpacity(widget.isDisabled ? 0.1 : 0.2);
        default:
          return AppPalette.greyColor
              .withOpacity(widget.isDisabled ? 0.1 : 0.2);
      }
    }

    Color getBorderColor() {
      switch (widget.widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.rejectedColor.withOpacity(0.4);
        case WidgetStatus.warning:
          return AppPalette.warningColor.withOpacity(0.4);
        default:
          return AppPalette.greyColor.withOpacity(0.4);
      }
    }

    Color getTextColor() {
      switch (widget.widgetStatus) {
        case WidgetStatus.error:
          return AppPalette.rejectedColor
              .withOpacity(widget.isDisabled ? 0.3 : 1.0);
        case WidgetStatus.warning:
          return AppPalette.warningColor
              .withOpacity(widget.isDisabled ? 0.3 : 1.0);
        default:
          return AppPalette.bodyTextColor
              .withOpacity(widget.isDisabled ? 0.3 : 1.0);
      }
    }

    return Container(
      height: widget.widgetSize == WidgetSizes.medium ? 40.h : 30.h,
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
          fixedSize: Size(widget.isFullWidth ? 395.w : double.infinity,
              widget.widgetSize == WidgetSizes.medium ? 40.h : 30.h),
          backgroundColor: AppPalette.transparentColor,
          shadowColor: AppPalette.transparentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        onPressed: widget.isDisabled ? null : widget.onPressed,
        icon: widget.isLoading
            ? RotationTransition(
                turns: _controller,
                child: Icon(
                  EvaIcons.loaderOutline,
                  color: AppPalette.whiteColor
                      .withOpacity(widget.isDisabled ? 0.5 : 1.0),
                ),
              )
            : widget.icon != null
                ? Icon(
                    widget.icon,
                    color: getTextColor(),
                    size: widget.widgetSize == WidgetSizes.medium ? 20.r : 16.r,
                  )
                : null,
        label: Text(
          widget.text,
          style: Theme.of(context).textTheme.buttonSecondary.copyWith(
                color: getTextColor(),
              ),
        ),
      ),
    );
  }
}
