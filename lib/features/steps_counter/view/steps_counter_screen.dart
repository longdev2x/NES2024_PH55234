import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/steps_entity.dart';
import 'package:nes24_ph55234/features/steps_counter/controller/steps_counter_provider.dart';
import 'package:nes24_ph55234/features/steps_counter/view/steps_counter_widget.dart';
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

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      ref.read(stepsCounterProvider.notifier).initPlatformState();
    } else if (status.isDenied) {
      AppToast.showToast("Không thể phát hiện bước chân khi bạn từ chối", length: Toast.LENGTH_LONG);
    } else if (status.isPermanentlyDenied) {
      // Mở cài đặt để người dùng cấp quyền
      openAppSettings();
    }
  }
  @override
  Widget build(BuildContext context) {
    final StepsEntity objSteps = ref.watch(stepsCounterProvider);
    return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: Column(children: [
          SizedBox(height: 40.h),
          StepsCounterMainCircle(objSteps: objSteps),
        ],),
        );
  }
}