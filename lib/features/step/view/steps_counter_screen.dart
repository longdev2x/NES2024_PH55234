import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/features/step/controller/step_counter_provider.dart';
import 'package:nes24_ph55234/features/step/view/set_target_step_widget.dart';
import 'package:nes24_ph55234/features/step/view/steps_counter_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class StepsCounterScreen extends ConsumerStatefulWidget {
  const StepsCounterScreen({super.key});

  @override
  ConsumerState<StepsCounterScreen> createState() => _StepsCounterScreenState();
}

class _StepsCounterScreenState extends ConsumerState<StepsCounterScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Đảm bảo đã xong giao diện hiện tại mới gọi
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
        context: context,
        builder: (ctx) => const SetTargetStepsWidget(isDaily: false),
      );
    });
  }

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      ref.read(stepCounterProvider.notifier).initPlatformState();
    } else if (status.isDenied) {
      AppToast.showToast("Không thể phát hiện bước chân khi bạn từ chối",
          length: Toast.LENGTH_LONG);
    } else if (status.isPermanentlyDenied) {
      // Mở cài đặt để người dùng cấp quyền
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final StepEntity objSteps = ref.watch(stepCounterProvider);
    final bool isStarted = ref.watch(onOffStepCounterProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            isStarted
                ? StepCounterMainCircle(objStep: objSteps)
                : const StepCounterMainCircleHolder(),
          ],
        ),
      ),
    );
  }
}
