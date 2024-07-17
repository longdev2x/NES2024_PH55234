import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/features/step/controller/step_counter_provider.dart';
import 'package:nes24_ph55234/features/step/controller/target_provider.dart';

class StepCounterMainCircleHolder extends ConsumerWidget {
  const StepCounterMainCircleHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCircularProgressContent(
      btnStart: () {
        ref.read(onOffStepCounterProvider.notifier).state = true;
        ref.read(stepCounterProvider.notifier).startNew();
      },
      isStart: true,
    );
  }
}

class StepCounterMainCircle extends ConsumerWidget {
  final StepEntity objStep;
  const StepCounterMainCircle({super.key, required this.objStep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchTargetStep =
        ref.watch(targetAsyncFamilyProvider(AppConstants.typeStepCounter));
    return GestureDetector(
      onTap: () {
        AppToast.showToast('Nhấn giữ để dừng nhé!');
      },
      onLongPress: () {
        ref.read(onOffStepCounterProvider.notifier).state = false;
        ref.read(stepCounterProvider.notifier).restartAndSave(objStep);
      },
      child: fetchTargetStep.when(
        data: (data) {
          return AppCircularProgressContent(
            step: objStep.step,
            targetStep: data?.target.toInt(),
            iconPath: ImageRes.icWalk,
            btnStart: () {},
          );
        },
        error: (error, stackTrace) => const Text('Error'),
        loading: () => AppCircularProgressContent(
          step: objStep.step,
          targetStep: 1500,
          iconPath: ImageRes.icWalk,
          btnStart: () {},
        ),
      ),
    );
  }
}

class CounterRowInfo extends ConsumerWidget {
  final StepEntity objStep;
  const CounterRowInfo(this.objStep, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final fetchTargetMetree =
        ref.watch(targetAsyncFamilyProvider(AppConstants.typeCaloCounter));
    final fetchTargeCalo =
        ref.watch(targetAsyncFamilyProvider(AppConstants.typeCaloCounter));
    final fetchTargetMinute =
        ref.watch(targetAsyncFamilyProvider(AppConstants.typeCaloCounter));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        fetchTargetMetree.when(
          data: (data) {
            final double percent =
                (objStep.metre / (data?.target ?? 100)).clamp(0.0, 1.0);
            return _conBg(
              iconPath: ImageRes.icArrowRight,
              percent: percent,
              title: '${objStep.metre} met',
              lable: 'Khoảng cách',
              isDark: isDark,
            );
          },
          error: (error, stackTrace) => const Text('Error'),
          loading: () => _conBg(
            iconPath: ImageRes.icArrowRight,
            percent: 0,
            title: 'met',
            lable: 'Khoảng cách',
            isDark: isDark,
          ),
        ),
        fetchTargeCalo.when(
          data: (data) {
            final double percent =
                (objStep.calo / (data?.target ?? 50)).clamp(0.0, 1.0);
            return _conBg(
              iconPath: ImageRes.icCalo,
              percent: percent,
              title: '${objStep.calo} kcal',
              lable: 'Calories',
              isDark: isDark,
            );
          },
          error: (error, stackTrace) => const Text('Error'),
          loading: () => _conBg(
            iconPath: ImageRes.icCalo,
            percent: 0,
            title: 'kcal',
            lable: 'Calories',
            isDark: isDark,
          ),
        ),
        fetchTargetMinute.when(
          data: (data) {
            final double percent =
                (objStep.minute / (data?.target ?? 50)).clamp(0.0, 1.0);
            return _conBg(
              iconPath: ImageRes.icTime,
              percent: percent,
              title: '${objStep.minute} phút',
              lable: 'Thời gian',
              isDark: isDark,
            );
          },
          error: (error, stackTrace) => const Text('Error'),
          loading: () => _conBg(
            iconPath: ImageRes.icTime,
            percent: 0,
            title: 'phút',
            lable: 'Thời gian',
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _conBg(
          {required String? iconPath,
          required double? percent,
          required String? title,
          required String? lable,
          required bool isDark}) =>
      Container(
        height: 140.h,
        width: 110.w,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: isDark ? Colors.white : Colors.black, width: 2.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppCircularProgressIcon(
              iconPath: iconPath,
              percent: percent,
              radius: 35,
              title: title,
            ),
            AppText14(
              lable,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
}

class CounterRowButton extends ConsumerWidget {
  final StepEntity objStep;
  const CounterRowButton(this.objStep, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButtonWithIcon(
              ontap: () {
                ref.read(stepCounterProvider.notifier).pause(true);
              },
              iconPath: ImageRes.icCalo,
              name: 'Tạm ngưng',
              width: 170,
              radius: 20,
            ),
            const Spacer(),
            AppButtonWithIcon(
              ontap: () {
                AppConfirm(
                  title: 'Bạn chắc chứ',
                  onConfirm: () {
                    ref.read(onOffStepCounterProvider.notifier).state = false;
                    ref
                        .read(stepCounterProvider.notifier)
                        .restartAndSave(objStep);
                  },
                );
              },
              iconPath: ImageRes.icCalo,
              name: 'Kết thúc',
              width: 170,
              radius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
