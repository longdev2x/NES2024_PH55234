import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingWidget1 extends StatelessWidget {
  const OnboardingWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                AppImage(
                  imagePath: ImageRes.clap,
                  height: 35.r,
                  width: 35.r,
                ),
                SizedBox(height: 15.h),
                const AppText40('Hello!'),
                SizedBox(height: 20.h),
              ],
            ),
            const Spacer(),
            Stack(clipBehavior: Clip.none, children: [
              Column(children: [
                SizedBox(height: 10.h),
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: AppColors.primaryElement.withOpacity(0.35),
                ),
              ]),
              Positioned(
                bottom: 0,
                right: -10,
                child: Container(
                    height: 175.h,
                    width: 150.h,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(ImageRes.avatarDefault, fit: BoxFit.cover,)),
              ),
            ]),
            SizedBox(width: 15.w),
          ],
        ),
        const AppText24(
          'Wellcome to Nes24 App. Cùng trải nghiệm những tính năng đầy hấp dẫn nhé',
          fontWeight: FontWeight.normal,
          maxLines: 3,
        ),
        SizedBox(
          height: 100.h,
        ),
      ],
    );
  }
}

class OnboardingWidget2 extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final double? size;
  const OnboardingWidget2(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      this.size});
  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppImage(
          imagePath: image,
          height: size != null ? size!.r : 150.r,
          width: size != null ? size!.r : 150.r,
        ),
        SizedBox(height: 20.h),
        AppText28(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 20),
        AppText20(subTitle, textAlign: TextAlign.center, maxLines: 3),
        SizedBox(height: 120.h),
      ],
    );
  }
}
