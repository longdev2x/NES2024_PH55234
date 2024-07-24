import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FriendEntity {
  final String id;
  final String name;
  final String? avatar;

  FriendEntity({
    String? id,
    required this.name,
    this.avatar,
  }) : id = id ?? const Uuid().v4();

  factory FriendEntity.fromJson(Map<String, dynamic> json) {
    return FriendEntity(
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class FriendshipEntity {
  final String id;
  final String userId;
  final String friendId;
  final String status;
  final DateTime createdAt;

  FriendshipEntity({
    String? id,
    required this.userId,
    required this.friendId,
    required this.status,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'user_id' : userId,
    'friend_id' : friendId,
    'status' : status,
    'created_at' : createdAt,
  };

  factory FriendshipEntity.fromJson(Map<String, dynamic> json) {
    return FriendshipEntity(
      userId: json['userId'] as String,
      friendId: json['friendId'] as String,
      status: json['status'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
