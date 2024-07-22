import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';

class ProfileRepos {
  static const String _c = AppConstants.cUser;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> updateUserProfile(UserEntity objUser) async {
    try {
      await _firestore.collection(_c).doc(objUser.id).update(objUser.toJson());
    } catch (e) {
      throw Exception('Lỗi update User: $e');
    }
  }

  static Future<UserEntity> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection(_c).doc(userId).get();
      return UserEntity.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Lỗi get User: $e');
    }
  }
}