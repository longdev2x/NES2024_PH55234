import 'package:flutter/material.dart';
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

class BMICategory {
  final String status;
  final double minBMI;
  final double maxBMI;
  final Color color;
  final String advise;

  BMICategory({
    required this.status,
    required this.minBMI,
    required this.maxBMI,
    required this.color,
    required this.advise,
  });

  bool isInRange(double bmi) => bmi >= minBMI && bmi < maxBMI;
}

final List<BMICategory> adultCategories = [
  BMICategory(
    status: 'Thiếu cân vô cùng trầm trọng',
    minBMI: 0,
    maxBMI: 16,
    color: Colors.red,
    advise: 'Làm ơn hãy gặp bác sĩ dinh dưỡng ngay lập tức!',
  ),
  BMICategory(
    status: 'Thiếu cân trầm trọng',
    minBMI: 16,
    maxBMI: 17,
    color: Colors.orange,
    advise: 'Hãy gặp chuyên gia dinh dưỡng để có được chế độ ăn uống phù hợp nhé',
  ),
  BMICategory(
    status: 'Thiếu cân',
    minBMI: 17,
    maxBMI: 18.5,
    color: Colors.yellow,
    advise: 'Hãy bổ sung đầy đủ chất béo, chất đạm để phát triển tốt hơn về cân nặng nhé',
  ),
  BMICategory(
    status: 'Bình thường',
    minBMI: 18.5,
    maxBMI: 25,
    color: Colors.green,
    advise: 'Xin chúc mừng! Bạn đang ở một vị trí tuyệt vời. Hãy duy trì các thói quen lành mạnh để duy trì cân nặng hợp lý.',
  ),
  BMICategory(
    status: 'Thừa cân',
    minBMI: 25,
    maxBMI: 30,
    color: Colors.yellow,
    advise: 'Hãy tập thể dục thường xuyên và ăn uống cân đối nhé',
  ),
  BMICategory(
    status: 'Béo phì cấp độ 1',
    minBMI: 30,
    maxBMI: 35,
    color: Colors.orange,
    advise: 'Hãy ngưng các chất ngọt và đồ ăn nhanh kèm theo tập thể dục thường xuyên hơn nhé',
  ),
  BMICategory(
    status: 'Béo phì cấp độ 2',
    minBMI: 35,
    maxBMI: 40,
    color: Colors.red,
    advise: 'Sẽ quá muộn nếu bạn không sớm điều chỉnh lại chế độ ăn uống và thể thao của bản thân',
  ),
  BMICategory(
    status: 'Béo phì cấp độ 3',
    minBMI: 40,
    maxBMI: double.infinity,
    color: Colors.purple,
    advise: 'Tới gặp bác sĩ dinh dưỡng ngay nhé, bạn sẽ cần lời khuyên từ họ đó!',
  ),
];

final List<BMICategory> childCategories = [
  BMICategory(
    status: 'Thiếu cân',
    minBMI: 0,
    maxBMI: 15,
    color: Colors.red,
    advise: 'Hãy cố gắng bổ sung đầy đủ chất dinh dưỡng ngay nhé',
  ),
  BMICategory(
    status: 'Bình thường',
    minBMI: 15,
    maxBMI: 21,
    color: Colors.green,
    advise: 'Xin chúc mừng! Bạn đang ở một vị trí tuyệt vời. Hãy duy trì các thói quen lành mạnh để duy trì cân nặng hợp lý.',
  ),
  BMICategory(
    status: 'Thừa cân',
    minBMI: 21,
    maxBMI: 24.2,
    color: Colors.yellow,
    advise: 'Hãy ngưng các chất ngọt và đồ ăn nhanh kèm theo tập thể dục thường xuyên hơn nhé',
  ),
  BMICategory(
    status: 'Béo phì',
    minBMI: 24.2,
    maxBMI: double.infinity,
    color: Colors.red,
    advise: 'Sẽ quá muộn nếu bạn không sớm điều chỉnh lại chế độ ăn uống và thể thao của bản thân',
  ),
];