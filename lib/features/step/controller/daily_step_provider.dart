import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:nes24_ph55234/main.dart';
import 'package:pedometer/pedometer.dart';
import 'package:health/health.dart';

class DailyStepAsyncNotifier
    extends AutoDisposeAsyncNotifier<List<StepEntity>> {
  Health health = Health();
  @override
  FutureOr<List<StepEntity>> build() {
    return _getDefaultValue();
  }

  String userId = Global.storageService.getUserId();
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

//Get data step 7 ngày gần nhất và tính các chỉ số còn lại cho objStep
  Future<void> setValueFromApi() async {
    final List<StepEntity> stepsList = [];
    print('zzzzz-1');
    // Configure the health plugin
    health.configure(useHealthConnectIfAvailable: true);
    print('zzzzz-2');
    // Define the types to get
    List<HealthDataType> types = [HealthDataType.STEPS];
    print('zzzzz-3');

    // Request permissions
    bool permission;
    permission = await health.hasPermissions(types) ?? false;
    if (!permission) {
      showDialog(
          context: navKey.currentContext!,
          builder: (ctx) {
            return AlertDialog(
              title: const AppText16(
                'Bạn cần cho phép truy cập vào dữ liệu của health connect để sử dụng tính năng',
                maxLines: 5,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      permission = await health.requestAuthorization(types);
                      navKey.currentState!.pop();
                      print('zzzzz-5 - Authorization permission: $permission');
                    },
                    child: const Text('Cho phép')),
                ElevatedButton(
                    onPressed: () async {
                      navKey.currentState!.pop();
                    },
                    child: const Text('Không'))
              ],
            );
          });
    }

    print('zzzzz-6 - Authorization permission: $permission');

    if (permission) {
      print('zzzzz-7');
      var now = DateTime.now();
      var sevenDaysAgo = now.subtract(const Duration(days: 7));

      for (int i = 0; i < 7; i++) {
        var startDate = sevenDaysAgo.add(Duration(days: i));
        var endDate = startDate.add(const Duration(days: 1));

        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          types: types,
          startTime: startDate,
          endTime: endDate,
        );
        print('zzzzz-8');

        //Bước chân của ngày hôm đó
        int totalSteps = healthData
            .where((dataPoint) => dataPoint.type == HealthDataType.STEPS)
            .fold(0, (sum, dataPoint) => sum + (dataPoint.value as int));
        print('zzzzz-9');
        StepEntity objStep = StepEntity(
          userId: userId,
          date: startDate,
          step: totalSteps,
          calo: calculateCalo(totalSteps),
          metre: calculateMetre(totalSteps),
          minute: calculateMinute(totalSteps),
        );

        stepsList.add(objStep);
        state = AsyncValue.data(stepsList);
      }
    } else {
      state = AsyncValue.data(_getDefaultValue());
    }
  }

  List<StepEntity> _getDefaultValue() {
    return [
      StepEntity(
        userId: userId,
        date: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        step: 1950,
        calo: 26,
        metre: 550,
        minute: 6,
      ),
    ];
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    // Huỷ đăng ký nếu đã tồn tại
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    //Khởi tạo
    _stepCountSubscription = _stepCountStream?.listen(
      onStepCount,
      onError: onStepCountError,
    );
    _pedestrianStatusSubscription = _pedestrianStatusStream?.listen(
      onPedestrianStatusChanged,
      onError: onPedestrianStatusError,
    );
  }

  void onStepCount(StepCount event) {
    final today = DateTime.now();
    final currentState = state.valueOrNull ?? [];

    StepEntity newObjStep;
    if (currentState.isEmpty || !currentState.last.date.isSameDate(today)) {
      newObjStep = StepEntity(userId: userId, date: today, step: event.steps);
      state = AsyncData([...currentState, newObjStep]);
    } else {
      final updatedStep = currentState.last.step + 1;
      final updatedCalo = calculateCalo(updatedStep);
      final updatedDistance = calculateMetre(updatedStep);
      final updatedDuration = calculateMinute(updatedStep);

      newObjStep = currentState.last.copyWith(
        step: updatedStep,
        calo: updatedCalo,
        metre: updatedDistance,
        minute: updatedDuration,
      );

      state = AsyncData(
          [...currentState.sublist(0, currentState.length - 1), newObjStep]);
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    final status = event.status;
    if (kDebugMode) {
      print('Trạng thái(daily): $status');
    }
  }

  void onPedestrianStatusError(error) {
    if (kDebugMode) {
      print('Trạng thái lỗi(daily): $error');
    }
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('Step Count Error(daily): $error');
    }
  }

  //Giả định là 1 bước đốt hết 0.0566 calo
  int calculateCalo(int step) {
    return (step * 0.0566).toInt();
  }

  //Tính theo mét, giả định sải bước trung bình 76.2
  int calculateMetre(int step) {
    return (step * 0.762).toInt();
  }

  // Giả định mất 1 phút để đi 100 bước
  int calculateMinute(int step) {
    return step ~/ 100;
  }

  void disposeStream() {
    _pedestrianStatusSubscription?.cancel();
    _stepCountSubscription?.cancel();
  }
}

final dailyStepProvider =
    AutoDisposeAsyncNotifierProvider<DailyStepAsyncNotifier, List<StepEntity>>(
        () => DailyStepAsyncNotifier());

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
