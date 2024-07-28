import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/services/notification_sevices.dart';
import 'package:nes24_ph55234/data/models/sleep_entity.dart';
import 'package:nes24_ph55234/data/repositories/sleep_repos.dart';
import 'package:nes24_ph55234/global.dart';

final isTrackingProvider = StateProvider<bool>(
  (ref) => false,
);
//Để rebuild lại giao diện ( Timer sẽ gọi provider này)
final currentTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

final sleepProvider = StateNotifierProvider<SleepNotifier, List<SleepEntity>>((ref) => SleepNotifier(),);

//Main
class SleepNotifier extends StateNotifier<List<SleepEntity>> {
  SleepNotifier() : super([]) {
    _fetchSleepEntries();
  }

  void _fetchSleepEntries() {
    SleepRepos.getSleepEntries(Global.storageService.getUserId())
        .listen((sleepEntries) {
      state = sleepEntries;
    });
  }

  Future<void> startSleep({required DateTime startTime}) async {
    final sleep = SleepEntity(
      userId: Global.storageService.getUserId(),
      startTime: startTime,
    );
    await SleepRepos.addSleep(sleep);
  }

  Future<void> stopSleep({required DateTime endTime}) async {
    final updatedSleep = state.first.copyWith(endTime: endTime);
    await SleepRepos.updateSleep(updatedSleep);
  }
}


//Set time nhắc ngủ + notification
final planBedProvider = StateNotifierProvider<PlanBedNotifier, TimeOfDay>((ref) => PlanBedNotifier());

class PlanBedNotifier extends StateNotifier<TimeOfDay> {
  PlanBedNotifier() : super(const TimeOfDay(hour: 22, minute: 0)) {
    _loadSavedTime();
  }

  Future<void> _loadSavedTime() async {
    final hour = Global.storageService.getHoursSleep();
    final minute = Global.storageService.getMinutesSleep();
    state = TimeOfDay(hour: hour, minute: minute);
    _scheduleSleepNotification();
  }

  Future<void> setTime(TimeOfDay time) async {
    state = time;
    await Global.storageService.setHoursSleep(time.hour);
    await Global.storageService.setMinutesSleep(time.minute);
    _scheduleSleepNotification();
  }

  void _scheduleSleepNotification() {
    print("zzzĐang gọi hàm lên lịch thông báo");
    NotificationServices().scheduleSleepNotification(state);
  }
}