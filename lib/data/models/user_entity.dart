import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';

const List<Role> listRoles = [
  Role(value: AppConstants.roleUser, name: 'Người dùng'),
  Role(value: AppConstants.roleExpert, name: 'Chuyên gia'),
  Role(value: AppConstants.roleAdmin, name: 'Admin'),
];

class Role {
  final String value;
  final String name;
  const Role({required this.value, required this.name});
}

class RememberPassEntity {
  final String email;
  final String password;
  final bool isRemember;
  const RememberPassEntity(
      {required this.email, required this.password, required this.isRemember});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'is_remember': isRemember,
      };

  factory RememberPassEntity.fromJson(Map<String, dynamic> json) =>
      RememberPassEntity(
        email: json['email'],
        password: json['password'],
        isRemember: json['is_remember'],
      );
}

class UserEntity {
  final String id;
  final String email;
  final Role role;
  final DateTime bith;
  final String username;
  final String gender;
  final String? token;
  List<String> friendIds;
  final String? avatar;
  final double? height;
  final double? weight;
  final double? bmi;
  List<String> category; //Chuyên gia

  UserEntity({
    required this.id,
    required this.email,
    required this.token,
    required this.role,
    required this.bith,
    String? username,
    required this.gender,
    this.avatar,
    this.height,
    this.weight,
    this.bmi,
    required this.friendIds,
    required this.category,
  }) : username = username ?? 'User${Random(100000).nextInt(1000000)}';

  UserEntity copyWith({
    String? email,
    String? username,
    String? token,
    Role? role,
    String? avatar,
    String? gender,
    double? height,
    double? weight,
    double? bmi,
    DateTime? bith,
    List<String>? friendIds,
    List<String>? category,
  }) =>
      UserEntity(
        id: id,
        email: email ?? this.email,
        token: token ?? this.token,
        role: role ?? this.role,
        username: username ?? this.username,
        avatar: avatar ?? this.avatar,
        bith: bith ?? this.bith,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        bmi: bmi ?? this.bmi,
        friendIds: friendIds ?? this.friendIds,
        category: category ?? this.category,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'token': token,
        'role': role.value,
        'username': username,
        'avatar': avatar,
        'gender': gender,
        'height': height,
        'weight': weight,
        'bmi': bmi,
        'bith': bith,
        'friend_ids': friendIds,
        'category': category,
      };

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      token: json['token'],
      role: listRoles.firstWhere((e) => e.value == json['role']),
      username: json['username'],
      avatar: json['avatar'],
      bith: (json['bith'] as Timestamp).toDate(),
      gender: json['gender'] ?? 'Nam',
      weight: json['weight'],
      height: json['height'],
      bmi: json['bmi'],
      friendIds: json['friend_ids'] != null ? (json['friend_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList() : [],
      category: json['category'] != null ? (json['category'] as List<dynamic>)
          .map((e) => e.toString())
          .toList() : [],
    );
  }
  String get bithFormat {
    var formatDate = DateFormat('dd-MM-yyyy');
    return formatDate.format(bith);
  }

  int? cacularAge() {
    DateTime today = DateTime.now();
    int age = today.year - bith.year;

    if (today.month < bith.month ||
        today.month == bith.month && today.day < bith.day) {
      age--;
    }
    return age;
  }

  double calculateBMI() {
    final bmi = weight! / ((height! / 100) * (height! / 100));
    return bmi;
  }
}
