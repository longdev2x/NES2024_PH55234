import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BMIEntity {
  final String? id;
  final String? userId;
  final DateTime date;
  final double? bmi;
  final int? age;
  final double? height;
  final double? weight;
  final String? gender;

  BMIEntity({
    String? id,
    required this.userId,
    required this.date,
    required this.bmi,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
  }) : id = id ?? const Uuid().v4();

  factory BMIEntity.fromJson(Map<String, dynamic> json) => BMIEntity(
        id: json['id'],
        userId: json['user_id'],
        date: (json['date'] as Timestamp).toDate(),
        bmi: json['bmi'],
        age: json['age'],
        height: json['height'],
        weight: json['weight'],
        gender: json['gender'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': Timestamp.fromDate(date),
        'bmi': bmi,
        'age': age,
        'height': height,
        'weight': weight,
        'gender': gender,
      };

  String get formatDate {
    final fomart = DateFormat("dd/MM/yyyy");
    return fomart.format(date);
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
    advise:
        'Hãy gặp chuyên gia dinh dưỡng để có được chế độ ăn uống phù hợp nhé',
  ),
  BMICategory(
    status: 'Thiếu cân',
    minBMI: 17,
    maxBMI: 18.5,
    color: Colors.yellow,
    advise:
        'Hãy bổ sung đầy đủ chất béo, chất đạm để phát triển tốt hơn về cân nặng nhé',
  ),
  BMICategory(
    status: 'Bình thường',
    minBMI: 18.5,
    maxBMI: 25,
    color: Colors.green,
    advise:
        'Xin chúc mừng! Bạn đang ở một vị trí tuyệt vời. Hãy duy trì các thói quen lành mạnh để duy trì cân nặng hợp lý.',
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
    advise:
        'Hãy ngưng các chất ngọt và đồ ăn nhanh kèm theo tập thể dục thường xuyên hơn nhé',
  ),
  BMICategory(
    status: 'Béo phì cấp độ 2',
    minBMI: 35,
    maxBMI: 40,
    color: Colors.red,
    advise:
        'Sẽ quá muộn nếu bạn không sớm điều chỉnh lại chế độ ăn uống và thể thao của bản thân',
  ),
  BMICategory(
    status: 'Béo phì cấp độ 3',
    minBMI: 40,
    maxBMI: double.infinity,
    color: Colors.purple,
    advise:
        'Tới gặp bác sĩ dinh dưỡng ngay nhé, bạn sẽ cần lời khuyên từ họ đó!',
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
    advise:
        'Xin chúc mừng! Bạn đang ở một vị trí tuyệt vời. Hãy duy trì các thói quen lành mạnh để duy trì cân nặng hợp lý.',
  ),
  BMICategory(
    status: 'Thừa cân',
    minBMI: 21,
    maxBMI: 24.2,
    color: Colors.yellow,
    advise:
        'Hãy ngưng các chất ngọt và đồ ăn nhanh kèm theo tập thể dục thường xuyên hơn nhé',
  ),
  BMICategory(
    status: 'Béo phì',
    minBMI: 24.2,
    maxBMI: double.infinity,
    color: Colors.red,
    advise:
        'Sẽ quá muộn nếu bạn không sớm điều chỉnh lại chế độ ăn uống và thể thao của bản thân',
  ),
];
