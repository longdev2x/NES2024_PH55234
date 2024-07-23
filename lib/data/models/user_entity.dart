import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

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

class UserEntity {
  final String id;
  final String email;
  final String password;
  final String role;
  final String? name;
  final String? avatar;
  final String? gender;
  final double? height;
  final double? weight;
  final int? age;
  final double? bmi;

  UserEntity({
    String? id,
    required this.email,
    required this.password,
    required this.role,
    this.name,
    this.avatar,
    this.gender,
    this.height,
    this.weight,
    this.bmi,
    this.age,
  }) : id = id ?? const Uuid().v4();

  UserEntity copyWith({
    String? email,
    String? password,
    String? name,
    String? role,
    String? avatar,
    String? gender,
    double? height,
    double? weight,
    double? bmi,
    int? age,
  }) =>
      UserEntity(
        id: id,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        bmi: bmi ?? this.bmi,
      );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'email' : email,
    'password' : password,
    'role' : role,
    'name' : name,
    'avatar' : avatar,
    'gender' : gender,
    'height' : height,
    'weight' : weight,
    'bmi' : bmi,
    'age' : age,
  };

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      name: json['name'],
      avatar: json['avatar'],
      age: json['age'],
      gender: json['gender'],
      weight: json['weight'],
      height: json['height'],
      bmi: json['bmi']
    );
  }
}
