import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';

class FriendRepos {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _cUsers = AppConstants.cUser;
  static const String _cFriendships = AppConstants.cFriendships;

  static Future<List<FriendEntity>> searchUsers(String query,
      {bool isEmail = false}) async {
    QuerySnapshot snapshot;
    if (isEmail) {
      snapshot = await _firestore
          .collection(_cUsers)
          .where('email', isEqualTo: query)
          .get();
    } else {
      snapshot = await _firestore
          .collection(_cUsers)
          //Bắt đầu bằng query...
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();
    }
    return snapshot.docs
        .map((doc) => FriendEntity.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<void> sendFriendRequest(FriendshipEntity objFriendShip) async {
    await _firestore
        .collection(_cFriendships)
        .doc(objFriendShip.id)
        .set(objFriendShip.toJson());
  }

  static Future<void> acceptFriendRequest(String friendshipId) async {
    await _firestore.runTransaction((transaction) async {
      final friendshipRef =
          _firestore.collection(_cFriendships).doc(friendshipId);
      final friendshipDoc = await transaction.get(friendshipRef);

      if (!friendshipDoc.exists) {
        throw Exception('Không tồn tại friendship');
      }

      final data = friendshipDoc.data() as Map<String, dynamic>;
      final userId = data['userId'] as String;
      final friendId = data['friendId'] as String;

      transaction.update(friendshipRef, {'status': 'accepted'});

      //thêm các phần tử vào một mảng mà không tạo ra bản sao, thêm bạn bè vào user của 2 người
      transaction.update(_firestore.collection(_cUsers).doc(userId), {
        'friend_ids': FieldValue.arrayUnion([friendId])
      });

      transaction.update(_firestore.collection(_cUsers).doc(friendId), {
        'friend_ids': FieldValue.arrayUnion([userId])
      });
    });
  }

  static Future<void> rejectFriendRequest(String friendshipId) async {
    await _firestore.collection(_cFriendships).doc(friendshipId).update({
      'status': 'rejected',
    });
  }

  //get Stream list tất cả lời mời đang pendding.
  static Stream<List<FriendshipEntity>> getFriendRequests(String userId) {
    return _firestore
        .collection(_cFriendships)
        //friendId == userId(xem có dc nhận lời mời k, trạng thái pending)
        .where('friendId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        //Tạo luồng stream
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FriendshipEntity.fromJson(doc.data()))
            .toList());
  }

  static Stream<List<FriendEntity>> getFriends(String userId) {
    return _firestore
        .collection(_cUsers)
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      final friendIds = List<String>.from(data['friendIds'] ?? []);
      if (friendIds.isEmpty) {
        return [];
      }
      final friendDocs = await _firestore
          .collection(_cUsers)
          //FieldPath.documentId là ID của document.
          //whereIn là xem phía bên trái ( id doc ) có nằm trong list bên phải k ( friendIds)
          //... Lấy tất cả các document trong collection '_cUsers' 
          //mà có ID nằm trong danh sách friendIds."
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();
      return friendDocs.docs
          .map((doc) => FriendEntity.fromJson(doc.data()))
          .toList();
    });
  }
}
