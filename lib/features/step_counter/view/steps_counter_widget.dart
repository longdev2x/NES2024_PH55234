import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/features/step_counter/controller/step_counter_provider.dart';

class StepCounterMainCircleHolder extends ConsumerWidget {
  const StepCounterMainCircleHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCircularProgressContent(
      btnStart: () {
        ref.read(onOffStepCounterProvider.notifier).state = true;
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
    return GestureDetector(
      onTap: () {
        AppToast.showToast('Nhấn giữ để dừng nhé!');
      },
      onLongPress: () {
        ref.read(onOffStepCounterProvider.notifier).state = false;
      },
      child: AppCircularProgressContent(
        step: objStep.step,
        targetStep: 1500,
        iconPath: ImageRes.clap,
      ),
    );
  }
}