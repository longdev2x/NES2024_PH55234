import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/features/step/controller/step_counter_provider.dart';
import 'package:nes24_ph55234/features/step/controller/step_target_provider.dart';

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
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeStepCounter));
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
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeCaloCounter));
    final fetchTargeCalo =
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeCaloCounter));
    final fetchTargetMinute =
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeCaloCounter));

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
    final isPaused = ref.watch(pauseStepCounterProvider);
    return SizedBox(
      height: 50.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButtonWithIcon(
              ontap: () {
                ref.read(stepCounterProvider.notifier).pause(!isPaused);
                ref.read(pauseStepCounterProvider.notifier).state = !isPaused;
              },
              iconPath: isPaused ? ImageRes.icPause : ImageRes.icResume,
              name: isPaused ? 'Tiếp tục' : 'Tạm ngưng',
              width: 170,
              radius: 20,
              iconColor: Colors.white,
            ),
            const Spacer(),
            AppButtonWithIcon(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AppConfirm(
                    title: 'Bạn chắc chứ',
                    onConfirm: () {
                      ref.read(onOffStepCounterProvider.notifier).state = false;
                      ref
                          .read(stepCounterProvider.notifier)
                          .restartAndSave(objStep);
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => _bottomShetShowResult(
                            context: ctx, objStep: objStep),
                        useSafeArea: true,
                        isScrollControlled: true,
                      );
                    },
                  ),
                );
              },
              iconPath: ImageRes.icStop,
              name: 'Kết thúc',
              width: 170,
              radius: 20,
              iconColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _bottomShetShowResult(
    {required BuildContext context, required StepEntity objStep}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppConstants.marginHori,
      vertical: 12.h,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppBar(
          title: const Text('Kết quả'),
          elevation: 0,
          leading: const SizedBox(),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        SizedBox(height: 50.h),
        Card(
          child: ListTile(
            leading: AppText40(
              objStep.step.toString(),
            ),
            subtitle: const Text('bước'),
            trailing: _radiusIcon(ImageRes.icWalk),
          ),
        ),
        Card(
          child: ListTile(
            leading: AppText40(
              objStep.calo.toString(),
            ),
            subtitle: const Text('calo'),
            trailing: _radiusIcon(ImageRes.icCalo),
          ),
        ),
        Card(
          child: ListTile(
            leading: AppText40(
              objStep.step.toString(),
            ),
            subtitle: const Text('met'),
            trailing: _radiusIcon(ImageRes.icArrowRight),
          ),
        ),
        Card(
          child: ListTile(
            leading: AppText40(
              objStep.step.toString(),
            ),
            subtitle: const Text('phút'),
            trailing: _radiusIcon(ImageRes.icTime),
          ),
        ),
      ],
    ),
  );
}

Widget _radiusIcon(String iconPath) => Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1)),
      child: AppIconAsset(path: iconPath),
    );
