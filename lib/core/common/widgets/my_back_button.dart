import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        EvaIcons.chevronLeftOutline,
        size: 32,
      ),
      color: AppPallete.bodyTextColor,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
