import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/features/steps_counter/controller/daily_step_provider.dart';
import 'package:nes24_ph55234/features/steps_counter/view/daily_steps_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class DailyStepsScreen extends ConsumerStatefulWidget {
  const DailyStepsScreen({super.key});

  @override
  ConsumerState<DailyStepsScreen> createState() => _DailyStepsScreenState();
}

class _DailyStepsScreenState extends ConsumerState<DailyStepsScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }
  
  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      ref.read(dailyStepProvider.notifier).initPlatformState();
    } else if (status.isDenied) {
      AppToast.showToast("Không thể phát hiện bước chân khi bạn từ chối", length: Toast.LENGTH_LONG);
    } else if (status.isPermanentlyDenied) {
      // Mở cài đặt để người dùng cấp quyền
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fetchList = ref.watch(dailyStepProvider);
    return Scaffold(
      appBar: appGlobalAppBar(title: 'Daily Steps'),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: fetchList.when(
          data: (listSteps) {
            return Column(children: [
              SizedBox(height: 40.h),
              StepsMainCircle(objSteps: listSteps.last),
              SizedBox(height: 55.h),
              StepsRowMoreInfor(objSteps: listSteps.last),
              SizedBox(height: 20.h),
              const StepsLineChart(),
            ]);
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
