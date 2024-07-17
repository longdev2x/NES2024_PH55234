import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';

class StepCounterRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _c = AppConstants.cStepCounter;

  static Future<List<StepEntity>?> getAllStepCounter(String userId) async {
    final querySnap = await _instance
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnap.docs
        .map((queryDoc) => StepEntity.fromJson(queryDoc.data()))
        .toList();
  }

  static Future<void> addStepCounter({required StepEntity objStep}) async {
    await _instance.collection(_c).doc(objStep.id).set(objStep.toJson());
  }
}
