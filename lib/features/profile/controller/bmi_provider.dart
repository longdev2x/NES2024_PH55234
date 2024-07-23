import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/data/repositories/bmi_repos.dart';

final indexScreenBMI = StateProvider<int>((ref) => 0);

final bmiLocalProvider = StateProvider<BMIEntity?>((ref) => null,);

class BMIAsyncNotifier extends AutoDisposeAsyncNotifier<BMIEntity?> {
  @override
  FutureOr<BMIEntity?> build() {
    return _loadFromFirebae();
  }

  Future<BMIEntity?> _loadFromFirebae() async {
    return BMIRepos.getLatestBMI();
  }

  Future<void> addBMI(BMIEntity objBMI) async {
    state = AsyncValue.data(objBMI);
    try {
      await BMIRepos.addBMI(objBMI);
    } on FirebaseException catch (e) {
      throw Exception(e);
    } finally {
      state = await AsyncValue.guard(() async => await _loadFromFirebae());
    }
  }
}

final bmiAsyncProvider =
    AutoDisposeAsyncNotifierProvider<BMIAsyncNotifier, BMIEntity?>(
        () => BMIAsyncNotifier());

class ListBMINotifier extends AutoDisposeAsyncNotifier<List<BMIEntity>?> {
  @override
  FutureOr<List<BMIEntity>?> build() {
    return _loadFromFirebae();
  }

  Future<List<BMIEntity>?> _loadFromFirebae() async {
    return BMIRepos.getAllBMI();
  }

  Future<void> deleteBMI(String id) async {
    await BMIRepos.deleteBMI(id);
  }
}

final listBMIProvider =
    AutoDisposeAsyncNotifierProvider<ListBMINotifier, List<BMIEntity>?>(
        () => ListBMINotifier());
