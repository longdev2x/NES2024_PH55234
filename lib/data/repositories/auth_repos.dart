import 'package:firebase_auth/firebase_auth.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/main.dart';

class AuthRepos {
  static final FirebaseAuth _instance = FirebaseAuth.instance;

  static Future<UserCredential> signUpWithFirebase({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  static Future<UserCredential> loginWithFirebase({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _instance.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  static Future<void> signOut() async {
    await _instance.signOut();
    navKey.currentState!.pushNamedAndRemoveUntil(AppRoutesNames.welcome, (route) => false);
  }
}