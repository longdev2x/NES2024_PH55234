import 'package:nes24_ph55234/common/components/app_slide_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSlideTransiton(
      begin: const Offset(0.0, -3.0),
      duration: const Duration(milliseconds: 1500),
      child: Text(
        "Sign In",
        style: TextStyle(
          fontSize: 38.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
