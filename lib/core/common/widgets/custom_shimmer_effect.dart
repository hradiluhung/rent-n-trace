import 'package:flutter/material.dart';
import 'package:rent_n_trace/core/theme/app_palette.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerEffect extends StatelessWidget {
  final Widget child;
  const CustomShimmerEffect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppPalette.greyColor.withOpacity(0.1),
      highlightColor: AppPalette.greyColor.withOpacity(0.3),
      child: child,
    );
  }
}
