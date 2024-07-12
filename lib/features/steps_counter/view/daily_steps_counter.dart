import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/features/steps_counter/view/daily_steps_counter_widgets.dart';

class DailyStepsCounterScreen extends StatelessWidget {
  const DailyStepsCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appGlobalAppBar(title: 'Theo dõi bước chân'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: Column(children: [
          SizedBox(height: 40.h),
          const StepsMainCircle(),
          SizedBox(height: 55.h),
          const StepsRowMoreInfor(),
          SizedBox(height: 20.h),
          const StepsLineChart(),
        ]),
      ),
    );
  }
}
