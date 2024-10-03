import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeleton extends StatelessWidget {
  final Widget child;
  const AppSkeleton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.black.withOpacity(0.1),
        highlightColor: Colors.black.withOpacity(0.2),
        duration: const Duration(seconds: 1),
      ),
      child: child,
    );
  }
}
