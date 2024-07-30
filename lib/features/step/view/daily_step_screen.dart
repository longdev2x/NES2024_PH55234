import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/features/step/controller/daily_step_provider.dart';
import 'package:nes24_ph55234/features/step/view/daily_step_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class DailyStepScreen extends ConsumerStatefulWidget {
  const DailyStepScreen({super.key});

  @override
  ConsumerState<DailyStepScreen> createState() => _DailyStepScreenState();
}

class _DailyStepScreenState extends ConsumerState<DailyStepScreen> {
  @override
  void dispose() {
    ref.read(dailyStepProvider.notifier).disposeStream();
    super.dispose();
  }
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
      AppToast.showToast("Không thể phát hiện bước chân khi bạn từ chối",
          length: Toast.LENGTH_LONG);
    } else if (status.isPermanentlyDenied) {
      // Mở cài đặt để người dùng cấp quyền
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fetchList = ref.watch(dailyStepProvider);
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: fetchList.when(
          data: (listStep) {
            return SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20.h),
                StepMainCircle(objStep: listStep.last),
                SizedBox(height: 35.h),
                StepRowMoreInfor(objStep: listStep.last),
                SizedBox(height: 10.h),
                const StepLineChart(),
              ]),
            );
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
