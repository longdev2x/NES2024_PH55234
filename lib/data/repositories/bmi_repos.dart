import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/global.dart';

class BMIRepos {
  static const String _c = AppConstants.cBMI;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<BMIEntity?> getLatestBMI() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(_c)
          .where('user_id', isEqualTo: Global.storageService.getUserId())
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return BMIEntity.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Lỗi get User: $e');
    }
  }

  static Future<List<BMIEntity>> getAllBMI() async {
    final snapshot = await _firestore.collection(_c).where('user_id', isEqualTo: Global.storageService.getUserId()).get();
    return snapshot.docs.map((e) => BMIEntity.fromJson(e.data())).toList();
  }

  static Future<void> addBMI(BMIEntity objBMI) async {
    try {
      await _firestore.collection(_c).doc(objBMI.id).set(objBMI.toJson());
    } catch (e) {
      throw Exception('Lỗi xóa BMI: $e');
    }
  }
  static Future<void> deleteBMI(String bmiId) async {
    try {
      await _firestore.collection(_c).doc(bmiId).delete();
    } catch (e) {
      throw Exception('Lỗi xóa BMI: $e');
    }
  }
}
