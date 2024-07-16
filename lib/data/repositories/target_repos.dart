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

  static Future<TargetEntity?> getTargetFollowType(
      String userId, String type) async {
    final querySnap = await _instance
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .get();

    if(querySnap.docs.isEmpty) {
      double target = 100;
      switch(type) {
        case AppConstants.typeStepDaily:
          target = 1000;
          break;
        case AppConstants.typeStepCounter:
          target = 2000;
          break;
        case AppConstants.typeCaloDaily:
          target = 50;
          break;
        case AppConstants.typeCaloCounter:
          target = 100;
          break;
        case AppConstants.typeMetreDaily:
          target = 500;
          break;
        case AppConstants.typeMetreCounter:
          target = 500;
          break;
        case AppConstants.typeMinuteDaily:
          target = 20;
          break;
        case AppConstants.typeMinuteCounter:
          target = 30;
          break;
      }
      TargetEntity objTarget = TargetEntity(userId: userId, type: type, target: target);
      updateTargetIfExistsOrAdd(objTarget);
      return objTarget;
    }

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
}
