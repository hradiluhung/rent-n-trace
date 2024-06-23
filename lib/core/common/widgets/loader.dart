import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatefulWidget {
  final String loadingText;
  const Loader({
    super.key,
    this.loadingText = "Loading",
  });

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  late Timer _timer;
  int _numDots = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _numDots = (_numDots + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/json/screen_loading.json',
            height: 150,
          ),
          SizedBox(height: 16.h),
          Text(
            "${widget.loadingText}${'.' * _numDots}",
            style: const TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}
