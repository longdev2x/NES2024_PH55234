import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:pedometer/pedometer.dart';

class StepsCounterNotifier extends StateNotifier<StepEntity> {
  StepsCounterNotifier()
      : super(StepEntity(
          userId: Global.storageService.getUserProfile().id,
          date: DateTime.now(),
        ));

  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

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
    final updatedSteps = state.steps + 1;
    final updatedCalories = calculateCalories(updatedSteps);
    final updatedDistance = calculateMetre(updatedSteps);
    final updatedDuration = calculateMinutes(updatedSteps);

    state = state.copyWith(
      steps: updatedSteps,
      calories: updatedCalories,
      metre: updatedDistance,
      minutes: updatedDuration,
    );
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
  int calculateCalories(int steps) {
    return (steps * 0.0566).toInt();
  }

  //Tính theo mét, giả định sải bước trung bình 76.2
  int calculateMetre(int steps) {
    return (steps * 0.762).toInt();
  }

  // Giả định mất 1 phút để đi 100 bước
  int calculateMinutes(int steps) {
    return steps ~/ 100;
  }
}

final stepsCounterProvider =
    StateNotifierProvider.autoDispose<StepsCounterNotifier, StepEntity>(
        (ref) => StepsCounterNotifier());

final onOffStepsCounterProvider = StateProvider<bool>((ref) => false);
