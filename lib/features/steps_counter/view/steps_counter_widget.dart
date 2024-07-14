import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/steps_entity.dart';

class StepsCounterMainCircleHolder extends StatelessWidget {
  const StepsCounterMainCircleHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCircularProgressContent(
      isStart: true,
    );
  }
}

class StepsCounterMainCircle extends StatelessWidget {
  final StepsEntity objSteps;
  const StepsCounterMainCircle({super.key, required this.objSteps});

  @override
  Widget build(BuildContext context) {
    return AppCircularProgressContent(
      steps: objSteps.steps,
      targetSteps: 1500,
      iconPath: ImageRes.clap,
    );
  }
}