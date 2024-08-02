import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/features/step/controller/step_target_provider.dart';
import 'package:nes24_ph55234/features/step/view/set_target_step_widget.dart';
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
    this.radius = 30.0,
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
          lineWidth: 5.r,
          circularStrokeCap: CircularStrokeCap.round,
          center: iconPath == null ? null : AppIconAsset(path: iconPath!),
        ),
        SizedBox(height: 5.h),
        Text(
          title ?? '',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
      ],
    );
  }
}

class AppCircularProgressContent extends ConsumerWidget {
  final Function()? btnStart;
  final int? step;
  final int? targetStep;
  final String? iconPath;
  final String? date;
  final double? radius;
  final bool? isStart;

  const AppCircularProgressContent({
    super.key,
    this.btnStart,
    this.step = 0,
    this.targetStep = 1000,
    this.iconPath,
    this.date,
    this.radius = 175,
    this.isStart = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<TargetEntity?> stepTarget = ref.watch(
        stepTargetAsyncFamilyProvider(btnStart != null
            ? AppConstants.typeStepCounter
            : AppConstants.typeStepDaily));
    double percent = (step! / targetStep!).clamp(0.0, 1.0);

    Widget btnTarget = stepTarget.when(
      data: (target) {
        return AppOutlineButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) =>
                    SetTargetStepsWidget(isDaily: btnStart == null),
              );
            },
            text: 'Target: ${target?.target.toInt().toString() ?? ''}');
      },
      error: (error, stackTrace) => const Text('Error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );

    return CircularPercentIndicator(
      radius: radius!,
      percent: targetStep != 0 ? percent : 0,
      backgroundColor: AppColors.primaryThreeElementText,
      progressColor: AppColors.primaryElement,
      backgroundWidth: 6.r,
      lineWidth: 10.r,
      circularStrokeCap: CircularStrokeCap.round,
      center: isStart!
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                btnTarget,
                SizedBox(height: 40.h),
                AppButton(
                  ontap: btnStart,
                  name: 'Let Go',
                  fontSize: 30,
                  width: 180,
                  radius: 100,
                  height: 60,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconPath != null
                    ? AppIconAsset(path: iconPath!, size: 35)
                    : const SizedBox(),
                Text(
                  step.toString(),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 80.sp),
                ),
                // btnStart != null ?
                btnStart == null
                    ? Text(
                        date ?? '',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w500),
                      )
                    : const SizedBox(),
                btnStart == null ? btnTarget : const SizedBox(),
              ],
            ),
    );
  }
}

class AppProgresTarget extends StatelessWidget {
  final double percent;
  final String name;
  final double? radius;
  final double? fontSize;

  const AppProgresTarget({
    super.key,
    required this.percent,
    required this.name,
    this.radius = 30.0,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius!,
      percent: percent,
      backgroundColor: AppColors.primaryThreeElementText,
      progressColor: AppColors.primaryElement,
      backgroundWidth: 4.r,
      lineWidth: 5.r,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        name,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    );
  }
}
