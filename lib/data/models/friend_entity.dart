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
    FriendEntity objFriend = FriendEntity(
      friendId: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      role: listRoles.firstWhere((role) => role.value == json['role']),
    );
    return objFriend;
  }
}

class FriendshipEntity {
  final String id;
  final String userId;
  final String friendId;
  final String status;
  final String senderUsername;
  final String? senderAvatar;
  final Role role;
  final DateTime createdAt;

  FriendshipEntity(
      {String? id,
      required this.userId,
      required this.friendId,
      required this.status,
      required this.senderUsername,
      this.senderAvatar,
      required this.role,
      required this.createdAt,})
      : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'friend_id': friendId,
        'status': status,
        'sender_username': senderUsername,
        'sender_avatar': senderAvatar,
        'role' : role.value,
        'created_at': createdAt,
      };

  factory FriendshipEntity.fromJson(Map<String, dynamic> json) {
    return FriendshipEntity(
      id: json['id'],
      userId: json['user_id'] as String,
      friendId: json['friend_id'] as String,
      status: json['status'] as String,
      senderUsername: json['sender_username'] ?? '',
      senderAvatar: json['sender_avatar'],
      role: listRoles.firstWhere((role) => role.value == json['role']),
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }
}
