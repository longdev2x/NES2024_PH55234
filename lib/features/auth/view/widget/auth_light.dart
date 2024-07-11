import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/common/components/app_slide_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLightWidget extends StatefulWidget {
  const AuthLightWidget({super.key});

  @override
  State<AuthLightWidget> createState() => _AuthLightWidgetState();
}

class _AuthLightWidgetState extends State<AuthLightWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSlideTransiton(
            isRepeat: true,
            child: Image.asset(
              ImageRes.imgLight,
              height: 195.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          AppSlideTransiton(
            isRepeat: true,
            curve: Curves.bounceInOut,
            child: Image.asset(
              ImageRes.imgLight,
              height: 150.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
