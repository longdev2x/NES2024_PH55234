import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/steps_entity.dart';
import 'package:nes24_ph55234/features/steps_counter/controller/steps_counter_provider.dart';

class StepsCounterMainCircleHolder extends ConsumerWidget {
  const StepsCounterMainCircleHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCircularProgressContent(
      btnStart: () {
        ref.read(onOffStepsCounterProvider.notifier).state = true;
      },
      isStart: true,
    );
  }
}

class StepsCounterMainCircle extends ConsumerWidget {
  final StepsEntity objSteps;
  const StepsCounterMainCircle({super.key, required this.objSteps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        AppToast.showToast('Nhấn giữ để dừng nhé!');
      },
      onLongPress: () {
        ref.read(onOffStepsCounterProvider.notifier).state = false;
      },
      child: AppCircularProgressContent(
        steps: objSteps.steps,
        targetSteps: 1500,
        iconPath: ImageRes.clap,
      ),
    );
  }
}