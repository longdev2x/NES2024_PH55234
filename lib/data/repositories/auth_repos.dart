import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/main.dart';

class AuthRepos {
  static final FirebaseAuth _instanceAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _instanceStore = FirebaseFirestore.instance;
  static const String c = AppConstants.cUser;

  static Future<UserCredential> signUpWithFirebase({
    required String email,
    required String password,
  }) async {
    return await _instanceAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> loginWithFirebase({
    required String email,
    required String password,
  }) async {
    return await _instanceAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> signOut() async {
    await _instanceAuth.signOut();
    navKey.currentState!
        .pushNamedAndRemoveUntil(AppRoutesNames.welcome, (route) => false);
  }

  static Future<UserEntity?> getUserInfor(String userId) async {
    final query =
        await _instanceStore.collection(c).where('id', isEqualTo: userId).get();
    return UserEntity.fromJson(query.docs.first.data());
  }

  static Future<void> setUserInfor(UserEntity objUser) async {
    await _instanceStore.collection(c).doc(objUser.id).set(objUser.toJson());
  }

  static Future<void> forgotPass(String email) async {
    await _instanceAuth.sendPasswordResetEmail(email: email);
  }

  static Future<void> changePass(String email, String currentPassword, String rePass) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    await user.reauthenticateWithCredential(cred);
    await _instanceAuth.currentUser!.updatePassword(rePass);
  }
}
