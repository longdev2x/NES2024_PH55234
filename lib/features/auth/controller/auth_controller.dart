import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/auth_repos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:nes24_ph55234/main.dart';

class AuthController {
  static void signUp({
    required String email,
    required String password,
    required Role role,
    required WidgetRef ref,
  }) async {
    //validate firebase (first validate in textformfield of Form)
    ref.read(loaderProvider.notifier).updateLoader(true);
    try {
      UserCredential userCredential = await AuthRepos.signUpWithFirebase(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) return;

      UserEntity objUser = UserEntity(id: user.uid, email: email, role: role, friendIds: []);

      try {
        await AuthRepos.setUserInfor(objUser);
      } catch (e) {
        AppToast.showToast('Hãy đăng ký lại');
        await user.delete(); 
        throw Exception("Lỗi khi lưu thông tin người dùng: $e");
      }

      await Global.storageService.setUserId(objUser.id);
      ref.read(loaderProvider.notifier).updateLoader(false);

      AppToast.showToast("Đăng ký thành công!");
      navKey.currentState!.pushNamedAndRemoveUntil(
          AppRoutesNames.application, (route) => false);
    } on FirebaseAuthException catch (e) {
      ref.read(loaderProvider.notifier).updateLoader(false);
      switch (e.code) {
        case "email-already-in-use":
          AppToast.showToast("Email đã được sử dụng");
          break;
        case "invalid-email":
          AppToast.showToast("Email không hợp lệ");
          break;
        case "weak-password":
          AppToast.showToast("Mật khẩu chưa đủ mạnh");
          break;
        case "operation-not-allowed":
          if (kDebugMode) {
            print("Chưa bật email-pass trên Firebase");
          }
          break;
        default:
          AppToast.showToast("Có lỗi gì đó");
      }
    }
  }

  static void signIn({
    required String email,
    required String password,
    required bool isRemember,
    required WidgetRef ref,
  }) async {
    //Validate Firebase (first validate in Form)
    ref.read(loaderProvider.notifier).updateLoader(true);
    try {
      UserCredential userCredential = await AuthRepos.loginWithFirebase(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) {
        AppToast.showToast('Kiểm tra lại tài khoản');
        return;
      }

      await Global.storageService.setUserId(user.uid);
      if (isRemember) {
        await Global.storageService.setRemember(
            email: email, password: password, isRemember: isRemember);
      } else {
        await Global.storageService
            .setRemember(email: '', password: '', isRemember: isRemember);
      }

      ref.read(loaderProvider.notifier).updateLoader(false);
      //Save user token to local, sharedpreferences ...
      navKey.currentState!.pushNamedAndRemoveUntil(
          AppRoutesNames.application, (route) => false);
    } on FirebaseAuthException catch (e) {
      ref.read(loaderProvider.notifier).updateLoader(false);
      switch (e.code) {
        case "user-disabled":
          AppToast.showToast("Tài khoản bị vô hiệu hoá");
          break;
        case "invalid-email":
          AppToast.showToast("Email không hợp lệ");
          break;
        case "user-not-found":
          AppToast.showToast("Email chưa đăng ký");
          break;
        case "wrong-password":
          AppToast.showToast("Sai mật khẩu");
          break;
        default:
          AppToast.showToast("Vui lòng kiểm tra lại");
      }
    }
  }
}
