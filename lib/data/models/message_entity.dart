import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatEntity {
  final String id;
  final String userId;
  final String partnerId;
  final String partnerUsername;
  final String? partnerAvatar;
  final String lastMsg;
  final DateTime time;
  final bool unread;

  ChatEntity({
    String? id,
    required this.userId,
    required this.partnerId,
    required this.lastMsg,
    required this.time,
    required this.partnerUsername,
    required this.partnerAvatar,
    this.unread = false,
  }) : id = id ?? const Uuid().v4();

  factory ChatEntity.fromJson(Map<String, dynamic> json) {
    return ChatEntity(
      id: json['id'],
      userId: json['user_id'],
      partnerId: json['partner_id'],
      partnerUsername: json['partner_username'],
      partnerAvatar: json['partner_avatar'],
      lastMsg: json['last_msg'],
      time: (json['time'] as Timestamp).toDate(),
      unread: json['unread'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'partner_id': partnerId,
        'partner_username': partnerUsername,
        'partner_avatar': partnerAvatar,
        'last_msg': lastMsg,
        'time': Timestamp.fromDate(time),
        'unread': unread,
      };
}

class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  MessageEntity({
    String? id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  }) : id = id ?? const Uuid().v4();

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'is_read': isRead,
    };
  }
}


String getTimeAgo(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);
  
  if (difference.inSeconds < 60) {
    return 'Vừa xong';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} phút trước';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} giờ trước';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} ngày trước';
  } else {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}