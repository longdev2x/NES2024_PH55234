import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/steps_entity.dart';
import 'package:pedometer/pedometer.dart';

class DailyStepsAsyncNotifier
    extends AutoDisposeAsyncNotifier<List<StepsEntity>> {
  @override
  FutureOr<List<StepsEntity>> build() {
    return _getValueFromApi();
  }

  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  List<StepsEntity> _getValueFromApi() {
    final list = [
      StepsEntity(
          date: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          steps: 150,
          calories: 5,
          metre: 10,
          minutes: 2),
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

    StepsEntity newObjSteps;
    if (currentState.isEmpty || !currentState.last.date.isSameDate(today)) {
      newObjSteps = StepsEntity(date: today, steps: event.steps);
      state = AsyncData([...currentState, newObjSteps]);
    } else {
      final updatedSteps = currentState.last.steps + 1;
      final updatedCalories = calculateCalories(updatedSteps);
      final updatedDistance = calculateMetre(updatedSteps);
      final updatedDuration = calculateMinutes(updatedSteps);

      newObjSteps = currentState.last.copyWith(
        steps: updatedSteps,
        calories: updatedCalories,
        metre: updatedDistance,
        minutes: updatedDuration,
      );

      state = AsyncData(
          [...currentState.sublist(0, currentState.length - 1), newObjSteps]);
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

final dailyStepProvider = AutoDisposeAsyncNotifierProvider<
    DailyStepsAsyncNotifier,
    List<StepsEntity>>(() => DailyStepsAsyncNotifier());

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
