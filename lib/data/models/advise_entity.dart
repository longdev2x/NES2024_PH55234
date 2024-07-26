import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

//1 cuộc trò chuyện
class AdviseSession {
  final String id;
  final String userId;
  final String content;
  final List<AdviseMessage> messages;
  final DateTime createdAt;

  AdviseSession({
    String? id,
    required this.userId,
    required this.content,
    required this.messages,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  factory AdviseSession.fromJson(Map<String, dynamic> json) {
    return AdviseSession(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      messages: (json['messages'] as List<dynamic>)
          .map((m) => AdviseMessage.fromJson(m))
          .toList(),
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'messages': messages.map((m) => m.toJson()).toList(),
        'created_at': Timestamp.fromDate(createdAt),
      };
}

//Mỗi tin nhắn
class AdviseMessage {
  final String message;
  final String senderId;
  final DateTime timestamp;
  final bool isExpert;

  AdviseMessage({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.isExpert,
  });

  factory AdviseMessage.fromJson(Map<String, dynamic> json) {
    return AdviseMessage(
      message: json['message'],
      senderId: json['sender_id'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isExpert: json['is_expert'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'sender_id': senderId,
        'timestamp': Timestamp.fromDate(timestamp),
        'is_expert': isExpert,
      };
}
