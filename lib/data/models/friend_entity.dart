import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:uuid/uuid.dart';

class FriendEntity {
  final String friendId;
  final String username;
  final String? avatar;
  final Role? role;

  FriendEntity({
    required this.friendId,
    required this.username,
    this.avatar,
    this.role,
  });

  factory FriendEntity.fromJson(Map<String, dynamic> json) {
    return FriendEntity(
      friendId: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      role: listRoles.firstWhere((role) => role.value == json['role']),
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
