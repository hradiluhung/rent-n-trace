import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onValueChanged;
  final String label;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onValueChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onValueChanged,
        ),
        Text(label),
      ],
    );
  }
}
