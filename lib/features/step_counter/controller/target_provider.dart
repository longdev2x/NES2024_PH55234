import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/data/repositories/target_repos.dart';
import 'package:nes24_ph55234/global.dart';

class TargetAsyncNotifier extends FamilyAsyncNotifier<TargetEntity?, String> {
  static late String userId;
  TargetAsyncNotifier() : super();

  @override
  FutureOr<TargetEntity?> build(String arg) async {
    userId = Global.storageService.getUserProfile().id;
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

final targetAsyncFamilyProvider =
    AsyncNotifierProviderFamily<TargetAsyncNotifier, TargetEntity?, String>(
        () => TargetAsyncNotifier());
