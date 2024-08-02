import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/services/notification_sevices.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/data/repositories/target_repos.dart';
import 'package:nes24_ph55234/global.dart';

class StepTargetAsyncNotifier extends FamilyAsyncNotifier<TargetEntity?, String> {
  static late String userId;
  StepTargetAsyncNotifier() : super();

  @override
  FutureOr<TargetEntity?> build(String arg) async {
    userId = Global.storageService.getUserId();
    return await _getTarget(arg);
  }

  Future<TargetEntity?> _getTarget(String type) async {
    return await TargetRepos.getTargetFollowType(userId, type);
  }

  Future<void> updateTarget({
    required double target,
    DateTime? dateStart,
    DateTime? dateEnd,
  }) async {
    state = state.whenData((objTarget) {
      objTarget = objTarget!.copyWith(
        target: target,
        dateStart: dateStart,
        dateEnd: dateEnd,
      );
      return objTarget;
    });

    //talk to sever
    try {
      await TargetRepos.updateTargetIfExistsOrAdd(state.value!);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    } finally {
      state = await AsyncValue.guard(() async => await _getTarget(arg));
    }
  }
}

final stepTargetAsyncFamilyProvider =
    AsyncNotifierProviderFamily<StepTargetAsyncNotifier, TargetEntity?, String>(
        () => StepTargetAsyncNotifier());



//Set time nhắc chạy + notification
final planWalkProvider = StateNotifierProvider<PlanWalkNotifier, TimeOfDay>((ref) => PlanWalkNotifier(ref));

class PlanWalkNotifier extends StateNotifier<TimeOfDay> {
  StateNotifierProviderRef? ref;
  PlanWalkNotifier(this.ref) : super(const TimeOfDay(hour: 6, minute: 0)) {
    _loadSavedTime();
  }

  Future<void> _loadSavedTime() async {
    final hour = Global.storageService.getHoursRun();
    final minute = Global.storageService.getMinutesRun();
    state = TimeOfDay(hour: hour, minute: minute);
    _scheduleSleepNotification();
  }

  Future<void> setTime(TimeOfDay time) async {
    state = time;
    await Global.storageService.setHoursRun(time.hour);
    await Global.storageService.setMinutesRun(time.minute);
    _scheduleSleepNotification();
  }

  void _scheduleSleepNotification() {
    print('zzz0101-$ref');
    //String channelId, String channelName, String title, String body, String payload, TimeOfDay sleepTime, StateNotifierProviderRef ref
    NotificationServices().scheduleSleepNotification('Run_channel_id', 'Run Notifications', 'Đã đến giờ chạy!', 'Nhấn để bắt đầu chạy', 'steps_screen', state, ref!);
  }
}