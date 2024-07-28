import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/data/models/sleep_entity.dart';

class SleepRepos {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = "sleep";

  static Future<void> addSleep(SleepEntity sleep) async {
    try {
      await _firestore.collection(_collection).doc(sleep.id).set(sleep.toJson());
    } catch (e) {
      throw Exception('Error adding sleep: $e');
    }
  }

  static Future<void> updateSleep(SleepEntity sleep) async {
    try {
      await _firestore.collection(_collection).doc(sleep.id).update(sleep.toJson());
    } catch (e) {
      throw Exception('Error updating sleep: $e');
    }
  }

  static Stream<List<SleepEntity>> getSleepEntries(String userId) {
    return _firestore
        .collection(_collection)
        .where('user_id', isEqualTo: userId)
        .orderBy('start_time', descending: true) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SleepEntity.fromJson(doc.data()))
          .toList();
    });
  }
}
