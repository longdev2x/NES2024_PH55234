import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';

class TargetRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _c = AppConstants.cTarget;

  static Future<List<TargetEntity>> getAllTarget(String userId) async {
    final querySnap = await _instance
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .orderBy('type', descending: true)
        .get();
    if(querySnap.docs.isEmpty) return [];
    return querySnap.docs
        .map((queryDoc) => TargetEntity.fromJson(queryDoc.data()))
        .toList();
  }

  static Future<TargetEntity?> getTargetFollowType(
      String userId, String type) async {
    final querySnap = await _instance
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .get();

    return querySnap.docs
        .map((queryDoc) => TargetEntity.fromJson(queryDoc.data()))
        .toList()
        .first;
  }

  static Future<void> updateTargetIfExistsOrAdd(TargetEntity objTarget) async {
    final docRef = _instance.collection(_c).doc(objTarget.id);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      docRef.update(objTarget.toJson());
    } else {
      docRef.set(objTarget.toJson());
    }
  }

  static Future<void> updateOrAddMultipleTargets(List<TargetEntity> targets) async {
  final batch = _instance.batch();
  for (var target in targets) {
    final docRef = _instance.collection(_c).doc(target.id);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      batch.update(docRef, target.toJson());
    } else {
      batch.set(docRef, target.toJson());
    }
  }
  await batch.commit();
}

}
