import 'package:flutter/material.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/primary_button.dart';
import 'package:rent_n_trace/features/booking/presentation/widgets/buttons/secondary_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String dismissText;
  final String confirmText;
  final String title;
  final String content;
  final Function onConfirm;
  final Function onDismiss;
  const ConfirmationDialog({
    super.key,
    required this.dismissText,
    required this.confirmText,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text('Konfirmasi', style: Theme.of(context).textTheme.headlineMedium),
      content: const Text('Apakah anda yakin ingin membatalkan booking ini?'),
      actions: [
        SecondaryButton(
          onPressed: () {
            onDismiss();
          },
          text: 'Tidak',
        ),
        PrimaryButton(
          onPressed: () {
            onConfirm();
          },
          text: 'Ya',
        ),
      ],
    );
  }
}
