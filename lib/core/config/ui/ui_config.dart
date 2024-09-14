import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BoxDecoration appBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF484848).withOpacity(0.24),
      offset: const Offset(0, 5),
      blurRadius: 5,
      spreadRadius: 2,
    )
  ],
);
