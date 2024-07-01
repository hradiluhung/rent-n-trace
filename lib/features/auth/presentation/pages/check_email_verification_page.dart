import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/widgets/smoot_contdown_indicator.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/welcome_page.dart';

class CheckEmailVerificationPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CheckEmailVerificationPage(),
      );
  const CheckEmailVerificationPage({super.key});

  @override
  State<CheckEmailVerificationPage> createState() =>
      _CheckEmailVerificationPageState();
}

class _CheckEmailVerificationPageState
    extends State<CheckEmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Silakan cek email Anda untuk verifikasi",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 20.h),
              SmoothCountdownIndicator(
                durationInSeconds: 5,
                onCountdownComplete: () {
                  Navigator.pushReplacement(
                    context,
                    WelcomePage.route(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
