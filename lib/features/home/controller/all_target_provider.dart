import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/data/repositories/target_repos.dart';
import 'package:nes24_ph55234/global.dart';

class AllTargetProvider extends AsyncNotifier<List<TargetEntity>> {
  @override
  FutureOr<List<TargetEntity>> build() {
    return _loadTarget();
  }
  Future<List<TargetEntity>> _loadTarget() async {
    return await TargetRepos.getAllTarget(Global.storageService.getUserId());
  }
  Future<void> updateAllTarget(List<TargetEntity> targets) async {
    state = AsyncValue.data(targets);
    await TargetRepos.updateOrAddMultipleTargets(targets);
    state = await AsyncValue.guard(() async => await TargetRepos.getAllTarget(Global.storageService.getUserId())); 
  }
  Future<void> setAllDefaultTarget() async {
    final String userId = Global.storageService.getUserId();
    List<TargetEntity> targets = [
      TargetEntity(userId: userId, type: AppConstants.typeStepDaily, target: 2500),
      TargetEntity(userId: userId, type: AppConstants.typeHoursSleep, target: 8),
      TargetEntity(userId: userId, type: AppConstants.typeHeight, target: 160),
      TargetEntity(userId: userId, type: AppConstants.typeWeight, target: 58),
      TargetEntity(userId: userId, type: AppConstants.typeBMI, target: 22),
      TargetEntity(userId: userId, type: AppConstants.typeCaloDaily, target: 1000),
      TargetEntity(userId: userId, type: AppConstants.typeMetreDaily, target: 5000),
      TargetEntity(userId: userId, type: AppConstants.typeMinuteDaily, target: 20),
      TargetEntity(userId: userId, type: AppConstants.typeStepCounter, target: 5000),
      TargetEntity(userId: userId, type: AppConstants.typeCaloCounter, target: 1200),
      TargetEntity(userId: userId, type: AppConstants.typeMetreCounter, target: 2400),
      TargetEntity(userId: userId, type: AppConstants.typeMinuteCounter, target: 30),
    ];
    await TargetRepos.updateOrAddMultipleTargets(targets);
  }
}

final allTargetProvider =
    AsyncNotifierProvider<AllTargetProvider, List<TargetEntity>>(
  () => AllTargetProvider(),
);
