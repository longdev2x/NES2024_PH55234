import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/auth/view/widget/auth_form.dart';
import 'package:nes24_ph55234/features/auth/view/widget/auth_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: double.infinity,
            height: 812.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageRes.imgBgLogin),
                  fit: BoxFit.fitHeight),
            ),
            child: Column(
              children: [
                const AuthLightWidget(),
                SizedBox(height: 25.h),
                const AuthFormWidget(),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final bool isLoader = ref.watch(loaderProvider);
              return Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 25.w,
                    height: 25.h,
                    child: CircularProgressIndicator(
                      color: isLoader ? null : Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}