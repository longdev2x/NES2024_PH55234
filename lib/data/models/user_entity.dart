import 'package:uuid/uuid.dart';

class UserEntity {
  final String id;
  final String email;
  final String role;
  final String? name;
  final String? avatar;
  final String? gender;
  final double? height;
  final double? weight;
  final double? bmi;
  final int? age;

  UserEntity({
    String? id,
    required this.email,
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
        email: email ?? this.email,
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
