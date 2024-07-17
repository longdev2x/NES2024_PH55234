import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/data/repositories/step_repos.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:pedometer/pedometer.dart';

class StepCounterNotifier extends StateNotifier<StepEntity> {
  StepCounterNotifier()
      : super(StepEntity(
          userId: Global.storageService.getUserProfile().id,
          date: DateTime.now(),
          step: -1
        ));

  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  void _initPlatformState() {
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

  Future<void> pause(bool isPause) async {
    if (isPause) {
      await _stepCountSubscription?.cancel();
      await _pedestrianStatusSubscription?.cancel();
      return;
    }
    _stepCountSubscription = _stepCountStream?.listen(
      onStepCount,
      onError: onStepCountError,
    );
    _pedestrianStatusSubscription = _pedestrianStatusStream?.listen(
      onPedestrianStatusChanged,
      onError: onPedestrianStatusError,
    );
  }

  Future<void> restartAndSave(StepEntity objStep) async {
    await StepCounterRepos.addStepCounter(objStep: objStep);
    await _stepCountSubscription?.cancel();
    await _pedestrianStatusSubscription?.cancel();
    state = StepEntity(
      userId: Global.storageService.getUserProfile().id,
      date: DateTime.now(),
    );
  }

  void startNew() {
    _initPlatformState();
  }

  void onStepCount(StepCount event) {
    final updatedStep = state.step + 1;
    final updatedCalo = calculateCalo(updatedStep);
    final updatedDistance = calculateMetre(updatedStep);
    final updatedDuration = calculateMinute(updatedStep);

    state = state.copyWith(
      step: updatedStep,
      calo: updatedCalo,
      metre: updatedDistance,
      minute: updatedDuration,
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

final stepCounterProvider =
    StateNotifierProvider.autoDispose<StepCounterNotifier, StepEntity>(
        (ref) => StepCounterNotifier());

final onOffStepCounterProvider =
    StateProvider.autoDispose<bool>((ref) => false);
