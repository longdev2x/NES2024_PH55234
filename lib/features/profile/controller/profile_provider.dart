import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/profile_repos.dart';
import 'package:nes24_ph55234/global.dart';

class ProfileNotifier extends AsyncNotifier<UserEntity> {
  static final String _userId = Global.storageService.getUserId();

  @override
  Future<UserEntity> build() async {
    return _loadUserProfile();
  }

  Future<UserEntity> _loadUserProfile() async {
    return await ProfileRepos.getUserProfile(_userId);
  }

  Future<void> updateUserProfile({
    String? email,
    String? password,
    String? name,
    Role? role,
    String? avatar,
    String? gender,
    double? height,
    double? weight,
    double? bmi,
    int? age,
  }) async {
    // Cập nhật state ngay lập tức để UI phản hồi nhanh
    state = AsyncData(state.value!.copyWith(
      email: email ?? state.value!.email,
      name: name ?? state.value!.name,
      role: role ?? state.value!.role,
      avatar: avatar ?? state.value!.avatar,
      gender: gender ?? state.value!.gender,
      height: height ?? state.value!.height,
      weight: weight ?? state.value!.weight,
      bmi: bmi ?? state.value!.bmi,
      age: age ?? state.value!.age,
    ));

//Làm việc với sever
    try {
      await ProfileRepos.updateUserProfile(state.value!);
    } catch (e) {
      state = await AsyncValue.guard(() async => await _loadUserProfile());
    }
  }
}


final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserEntity>(() {
  return ProfileNotifier();
});

final bottomNavBMI = StateProvider<int>((ref) => 0);