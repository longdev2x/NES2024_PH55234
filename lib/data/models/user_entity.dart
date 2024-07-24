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
  final String? name;
  final String? avatar;
  final String? gender;
  final double? height;
  final double? weight;
  final int? age;
  final double? bmi;
  List<String> friendIds;

  UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.avatar,
    this.gender,
    this.height,
    this.weight,
    this.bmi,
    this.age,
    required this.friendIds,
  });

  UserEntity copyWith({
    String? email,
    String? name,
    Role? role,
    String? avatar,
    String? gender,
    double? height,
    double? weight,
    double? bmi,
    int? age,
    List<String>? friendIds,
  }) =>
      UserEntity(
        id: id,
        email: email ?? this.email,
        role: role ?? this.role,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        bmi: bmi ?? this.bmi,
        friendIds: friendIds ?? this.friendIds,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role.value,
        'name': name,
        'avatar': avatar,
        'gender': gender,
        'height': height,
        'weight': weight,
        'bmi': bmi,
        'age': age,
        'friend_ids': friendIds,
      };

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      role: listRoles.firstWhere((e) => e.value == json['role']),
      name: json['name'],
      avatar: json['avatar'],
      age: json['age'],
      gender: json['gender'],
      weight: json['weight'],
      height: json['height'],
      bmi: json['bmi'],
      friendIds: (json['friend_ids'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}
