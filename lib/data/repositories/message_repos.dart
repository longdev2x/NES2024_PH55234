import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/services/notification_sevices.dart';
import 'package:nes24_ph55234/data/models/message_entity.dart';
import 'package:nes24_ph55234/global.dart';

class MessageRepos {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createChat(ChatEntity objChat) async {
    final existingChat = await _firestore
        .collection('chats')
        .where('user_id', isEqualTo: objChat.userId)
        .where('partner_id', isEqualTo: objChat.partnerId)
        .limit(1)
        .get();

    if (existingChat.docs.isNotEmpty) {
      // Nếu chat đã tồn tại, cập nhật thông tin
      String chatId = existingChat.docs.first.id;
      await _firestore.collection('chats').doc(chatId).update({
        'last_msg': objChat.lastMsg,
        'time': Timestamp.fromDate(objChat.time),
        'unread': objChat.unread,
      });
    } else {
      // Nếu chat chưa tồn tại, tạo mới
      await _firestore
          .collection('chats')
          .doc(objChat.id)
          .set(objChat.toJson());
    }
  }

  static Stream<List<ChatEntity>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('user_id', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatEntity.fromJson(doc.data()))
          .toList();
    });
  }

  static Stream<List<MessageEntity>> getMessages(
      String userId, String friendId) {
    return _firestore
        .collection('messages')
        //sender hoặc receiver nhận tùng khớp thì đều lấy
        .where(Filter.or(
            Filter.and(Filter('sender_id', isEqualTo: userId),
                Filter('receiver_id', isEqualTo: friendId)),
            Filter.and(Filter('sender_id', isEqualTo: friendId),
                Filter('receiver_id', isEqualTo: userId))))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageEntity.fromJson(doc.data()))
          .toList();
    });
  }

  static Future<void> sendMessage(MessageEntity objMessage) async {
    await _firestore.collection('messages').add(objMessage.toJson());
    //Update last mess + seen
    QuerySnapshot chatQuery = await _firestore
        .collection('chats')
        .where('user_id', isEqualTo: objMessage.senderId)
        .where('partner_id', isEqualTo: objMessage.receiverId)
        .limit(1)
        .get();

    String chatId = chatQuery.docs.first.id;
    await _firestore.collection('chats').doc(chatId).update({
      'last_msg': objMessage.content,
      'time': Timestamp.fromDate(objMessage.timestamp),
      'unread': Global.storageService.getUserId() != objMessage.senderId,
    });


    if (Global.storageService.getUserId() == objMessage.senderId) {
      NotificationServices().sendNotification(
        type: 'chat',
        receiverToken: await getUserToken(objMessage.receiverId),
        title: "Tin nhắn mới",
        body: objMessage.content,
      );
    }
  }
  //Lấy token người nhận
  static Future<String> getUserToken(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('user').doc(userId).get();
    return userDoc['fcmToken'] ?? '';
  }

  static Future<void> markMessageAsRead(String messageId) async {
    await _firestore
        .collection('messages')
        .doc(messageId)
        .update({'is_read': true});
  }
}
