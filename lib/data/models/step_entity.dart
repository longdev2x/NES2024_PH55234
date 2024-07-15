import 'package:uuid/uuid.dart';

class StepEntity {
  final String id;
  final String userId;
  final DateTime date;
  final int steps;
  final int calories;
  final int metre;
  final int minutes;

  StepEntity({
    String? id,
    required this.userId,
    required this.date,
    this.steps = 0,
    this.calories = 0,
    this.metre = 0,
    this.minutes = 0,
  }) : id = id ?? const Uuid().v4();

  StepEntity copyWith({
    DateTime? date,
    int? steps,
    int? calories,
    int? metre,
    int? minutes,
  }) =>
      StepEntity(
        id: id,
        userId: userId,
        date: date ?? this.date,
        steps: steps ?? this.steps,
        calories: calories ?? this.calories,
        metre: metre ?? this.metre,
        minutes: minutes ?? this.minutes,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': date,
        'steps': steps,
        'calo': calories,
        'metre': metre,
        'minutes': minutes,
      };

  factory StepEntity.fromJson(Map<String, dynamic> json) => StepEntity(
        id: json['id'],
        userId: json['user_id'],
        date: json['date'],
        steps: json['steps'],
        calories: json['calo'],
        metre: json['metre'],
        minutes: json['minutes'],
      );
}
