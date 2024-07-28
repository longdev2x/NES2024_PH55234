import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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