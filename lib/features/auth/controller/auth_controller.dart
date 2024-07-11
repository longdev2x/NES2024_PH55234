import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:nes24_ph55234/data/repositories/auth_repos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/main.dart';

class AuthController {
  static void signUp({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    //validate firebase (first validate in textformfield of Form)
    ref.read(loaderProvider.notifier).updateLoader(true);
    try {
      UserCredential userCredential = await AuthRepos.signUpWithFirebase(
        email: email,
        password: password,
      );
      userCredential.user!.sendEmailVerification();
      ref.read(loaderProvider.notifier).updateLoader(false);
      AppToast.showToast("Thành công, vui lòng xác thực email");
      //Add username, photo...
      navKey.currentState!
          .pushNamedAndRemoveUntil('/application', (route) => false);
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
    required WidgetRef ref,
  }) async {
    //Validate Firebase (first validate in Form)
    ref.read(loaderProvider.notifier).updateLoader(true);
    try {
      await AuthRepos.loginWithFirebase(
        email: email,
        password: password,
      );
      ref.read(loaderProvider.notifier).updateLoader(false);
      //Save user token to local, sharedpreferences ...
      navKey.currentState!
          .pushNamedAndRemoveUntil('/application', (route) => false);
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
