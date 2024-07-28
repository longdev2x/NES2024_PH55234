import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/profile_repos.dart';
import 'package:nes24_ph55234/global.dart';

class ProfileNotifier extends AutoDisposeAsyncNotifier<UserEntity> {
  @override
  Future<UserEntity> build() async {
    return _loadUserProfile();
  }

  Future<UserEntity> _loadUserProfile() async {
    return await ProfileRepos.getUserProfile(Global.storageService.getUserId());
  }

  Future<void> updateUserProfile({
    String? email,
    String? password,
    String? username,
    Role? role,
    File? avatarFile,
    String? gender,
    double? height,
    double? weight,
    double? bmi,
    DateTime? bith,
    List<String>? category,
  }) async {
    String? newAvatarUrl;
    if (avatarFile != null) {
      ref.read(loaderProvider.notifier).state = true;
      newAvatarUrl = await ProfileRepos.uploadAvatar(
          Global.storageService.getUserId(), avatarFile);
    }
    try {
      // Cập nhật state ngay lập tức để UI phản hồi nhanh
      state = AsyncData(state.value!.copyWith(
        email: email,
        username: username ,
        role: role,
        avatar: newAvatarUrl,
        gender: gender,
        height: height,
        weight: weight,
        bmi: bmi,
        bith: bith,
        category: category
      ));

      print('zzz-list${category.toString()}');
      await ProfileRepos.updateUserProfile(state.value!);
      state = await AsyncValue.guard(() async => await _loadUserProfile());
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      ref.read(loaderProvider.notifier).state = false;
    }
  }

}

final profileProvider =
    AutoDisposeAsyncNotifierProvider<ProfileNotifier, UserEntity>(() {
  return ProfileNotifier();
});

final bottomNavBMI = StateProvider<int>((ref) => 0);
