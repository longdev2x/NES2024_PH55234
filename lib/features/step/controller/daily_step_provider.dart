import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:pedometer/pedometer.dart';

class DailyStepAsyncNotifier
    extends AutoDisposeAsyncNotifier<List<StepEntity>> {
  @override
  FutureOr<List<StepEntity>> build() {
    return _getValueFromApi();
  }
  UserEntity objUser = Global.storageService.getUserProfile();
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  List<StepEntity> _getValueFromApi() {
    final list = [
      StepEntity(
          userId: objUser.id,
          date: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          step: 1250,
          calo: 5,
          metre: 10,
          minute: 2),
    ];
    return list;
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
      newObjStep = StepEntity(userId: objUser.id, date: today, step: event.steps);
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
      print('Trạng thái: $status');
    }
  }

  void onPedestrianStatusError(error) {
    if (kDebugMode) {
      print('Trạng thái lỗi: $error');
    }
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('Step Count Error: $error');
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
}

final dailyStepProvider = AutoDisposeAsyncNotifierProvider<
    DailyStepAsyncNotifier,
    List<StepEntity>>(() => DailyStepAsyncNotifier());

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
