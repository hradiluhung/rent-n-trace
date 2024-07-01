import 'dart:async';

import 'package:flutter/material.dart';

class SmoothCountdownIndicator extends StatefulWidget {
  final double durationInSeconds;
  final VoidCallback? onCountdownComplete;

  const SmoothCountdownIndicator({
    super.key,
    required this.durationInSeconds,
    this.onCountdownComplete,
  });

  @override
  State<SmoothCountdownIndicator> createState() =>
      _SmoothCountdownIndicatorState();
}

class _SmoothCountdownIndicatorState extends State<SmoothCountdownIndicator> {
  double _timeLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.durationInSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    const tick = 0.1;
    _timer =
        Timer.periodic(Duration(milliseconds: (tick * 1000).round()), (timer) {
      setState(() {
        _timeLeft -= tick;
        if (_timeLeft <= 0) {
          _timer?.cancel();
          widget.onCountdownComplete?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: _timeLeft / widget.durationInSeconds,
    );
  }
}
