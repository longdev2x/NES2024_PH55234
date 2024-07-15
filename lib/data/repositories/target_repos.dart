import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';

class TargetRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _c = AppConstants.cTarget;

  static Future<List<TargetEntity>?> getAllTarget(String userId) async {
    final querySnap = await _instance
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnap.docs
        .map((queryDoc) => TargetEntity.fromJson(queryDoc.data()))
        .toList();
  }

  static Future<List<TargetEntity>?> getTargetFollowType(String userId, String type) async {
    final querySnap = await _instance
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .get();
    return querySnap.docs
        .map((queryDoc) => TargetEntity.fromJson(queryDoc.data()))
        .toList();
  }

  static Future<void> addTarget(TargetEntity objTarget) async {
    await _instance.collection(_c).doc(objTarget.id).set(objTarget.toJson());
  }

  static Future<void> updateTarget(TargetEntity objTarget) async {
    _instance.collection(_c).doc(objTarget.id).update(objTarget.toJson());
  }

  static Future<void> batchUpdateTarget(List<TargetEntity> targets) async {
    final batch = _instance.batch();
    for (final target in targets) {
      final docRef = _instance.collection(_c).doc(target.id);
      batch.set(docRef, target.toJson());
    }
    await batch.commit();
  }
}
