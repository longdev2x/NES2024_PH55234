import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AppCircularProgressIcon extends StatelessWidget {
  final double? percent;
  final String? iconPath;
  final String? title;
  final double? radius;
  const AppCircularProgressIcon({
    super.key,
    this.percent = 80.0,
    this.iconPath,
    this.title,
    this.radius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: radius!,
          percent: percent!,
          backgroundColor: AppColors.primaryThreeElementText,
          progressColor: AppColors.primaryElement,
          backgroundWidth: 4.r,
          lineWidth: 4.r,
          center: iconPath == null ? null : AppIcon(path: iconPath!),
        ),
        SizedBox(height: 5.h),
        Text(
          title ?? '',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class AppCircularProgressContent extends StatelessWidget {
  final int? steps;
  final int? targetSteps;
  final String? iconPath;
  final String? date;
  final double? radius;
  final bool? isStart;
  const AppCircularProgressContent({
    super.key,
    this.steps = 0,
    this.targetSteps = 1000,
    this.iconPath,
    this.date,
    this.radius = 130,
    this.isStart = false,
  });

  @override
  Widget build(BuildContext context) {
    double percent = (steps! / targetSteps!).clamp(0.0, 1.0);
    return CircularPercentIndicator(
      radius: radius!,
      percent: targetSteps != 0 ? percent : 0,
      backgroundColor: AppColors.primaryThreeElementText,
      progressColor: AppColors.primaryElement,
      backgroundWidth: 10.r,
      lineWidth: 10.r,
      center: isStart! 
      ? const AppText40('Được rồi đi thôi!')
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconPath != null ? AppIcon(path: iconPath!) : const SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.r),
            child: Text(
              steps.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
            ),
          ),
          Text(date ?? ''),
          Text('MỤC TIÊU $targetSteps'),
        ],
      ),
    );
  }
}
