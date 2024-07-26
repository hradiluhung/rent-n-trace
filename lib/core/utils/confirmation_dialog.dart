import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/constants/widget_contants.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/core/common/widgets/buttons/secondary_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String dismissText;
  final String confirmText;
  final String title;
  final String content;
  final Function onConfirm;
  final Function onDismiss;
  final int confirmStatus;
  final bool isLoading;

  const ConfirmationDialog({
    super.key,
    required this.dismissText,
    required this.confirmText,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onDismiss,
    this.confirmStatus = WidgetStatus.normal,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      content: Text(content),
      actions: [
        SecondaryButton(
          onPressed: () {
            onDismiss();
          },
          text: 'Tidak',
          widgetSize: WidgetSizes.small,
        ),
        PrimaryButton(
          onPressed: () {
            onConfirm();
          },
          text: 'Ya',
          widgetSize: WidgetSizes.small,
          widgetStatus: confirmStatus,
          isDisabled: isLoading,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
