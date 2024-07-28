import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/data/models/advise_entity.dart';

class AdviseRepos {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Phía màn danh sách tin nhắn
  //Phía user - Tạo cuộc tư vấn
  static Future<void> createAdviseSession(AdviseSession session) async {
    await _firestore
        .collection('advise')
        .doc(session.id)
        .set(session.toJson());
  }

  //Phía user - get tất cả các cuộc tư vấn của current User
  static Stream<List<AdviseSession>> getUserAdviseSessions(String userId) {
    return _firestore
        .collection('advise')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AdviseSession.fromJson(doc.data()))
          .toList();
    });
  }

  //Phía Expert, get tất cả các cuộc tư vấn
  static Stream<List<AdviseSession>> getAllAdviseSessions() {
    return _firestore
        .collection('advise')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AdviseSession.fromJson(doc.data()))
          .toList();
    });
  }

  //Màn hình nhắn mỗi cuộc nhắn tin
  //Stream nội dung tin nhắn để trả về màn nhắn tin chi tiết
  static Stream<AdviseSession> getAdviseSessionStream(String sessionId) {
    return _firestore
        .collection('advise')
        .doc(sessionId)
        .snapshots()
        .map((doc) => AdviseSession.fromJson(doc.data()!));
  }

  //Nhắn tin.Người gửi nhắn tin
  static Future<void> addMessageToSession(
      String sessionId, AdviseMessage message) async {
    await _firestore.collection('advise').doc(sessionId).update({
      'messages': FieldValue.arrayUnion([message.toJson()])
    });
  }

  //Chuyên gia trả lời.
  static Future<void> addResponse(String sessionId, String response) async {
    await _firestore.collection('advise').doc(sessionId).update({
      'responses': FieldValue.arrayUnion([response])
    });
  }
  // Lấy cuộc trò chuyện theo từng category
  static Stream<List<AdviseSession>> getSessionsByCategory(
      List<String> categories) {
    return FirebaseFirestore.instance
        .collection('advise_sessions')
        .where('category', whereIn: categories)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdviseSession.fromJson(doc.data()))
            .toList());
  }
}
