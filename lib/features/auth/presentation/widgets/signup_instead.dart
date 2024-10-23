import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rent_n_trace/core/common/helpers/navigator/app_navigator.dart';
import 'package:rent_n_trace/core/config/theme/app_colors.dart';
import 'package:rent_n_trace/features/auth/presentation/pages/signup_page.dart';

class SignUpInstead extends StatelessWidget {
  const SignUpInstead({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun? ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
        ),
        InkWell(
          splashColor: Colors.black.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.1),
          onTap: () {
            AppNavigator.push(context, SignupPage());
          },
          child: Text('Daftar',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
      ],
    );
  }
}
