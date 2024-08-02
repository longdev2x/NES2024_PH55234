import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/services/notification_sevices.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/data/repositories/target_repos.dart';
import 'package:nes24_ph55234/global.dart';

class SleepTargetNotifier extends AsyncNotifier<TargetEntity?>{
  @override
  FutureOr<TargetEntity?> build() {
    return _load();
  }
  Future<TargetEntity?> _load() async {
    return await TargetRepos.getTargetFollowType(Global.storageService.getUserId(), AppConstants.typeHoursSleep);
  }
  Future<void> setTarget(double hours) async {
    state = AsyncValue.data(state.value?.copyWith(target: hours));
    await TargetRepos.updateTargetIfExistsOrAdd(state.value!);
    state = await AsyncValue.guard(()async => await _load());
  }
}

final sleepTargetProvider = AsyncNotifierProvider<SleepTargetNotifier, TargetEntity?>(() {
  return SleepTargetNotifier();
},);



//Set time nhắc ngủ + notification
final planBedProvider = StateNotifierProvider<PlanBedNotifier, TimeOfDay>((ref) => PlanBedNotifier(ref));

class PlanBedNotifier extends StateNotifier<TimeOfDay> {
  StateNotifierProviderRef? ref;
  PlanBedNotifier(this.ref) : super(const TimeOfDay(hour: 22, minute: 0)) {
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
    print('zzz0101-$ref');
    //String channelId, String channelName, String title, String body, String payload, TimeOfDay sleepTime, StateNotifierProviderRef ref
    NotificationServices().scheduleSleepNotification('sleep_channel_id', 'Sleep Notifications', 'Đã đến giờ ngủ!', 'Nhấn để bắt đầu theo dõi giấc ngủ của bạn.', 'sleep_screen', state, ref!);
  }
}