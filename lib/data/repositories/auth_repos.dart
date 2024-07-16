import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/main.dart';

class AuthRepos {
  static final FirebaseAuth _instanceAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _instanceStore = FirebaseFirestore.instance;
  static const String c = AppConstants.cAuth;

  static Future<UserCredential> signUpWithFirebase({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _instanceAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  static Future<UserCredential> loginWithFirebase({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _instanceAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  static Future<void> signOut() async {
    await _instanceAuth.signOut();
    navKey.currentState!.pushNamedAndRemoveUntil(AppRoutesNames.welcome, (route) => false);
  }

  static Future<UserEntity?> getUserInfor(String userId) async {
    final query = await _instanceStore.collection(c).where('id', isEqualTo: userId).get();
    return UserEntity.fromJson(query.docs.first.data());
  }

  static Future<void> setUserInfor(UserEntity objUser) async {
    await _instanceStore.collection(c).add(objUser.toJson());
  }
}