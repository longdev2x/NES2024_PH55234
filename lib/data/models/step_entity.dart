import 'package:uuid/uuid.dart';

class StepEntity {
  final String id;
  final String userId;
  final DateTime date;
  final int step;
  final int calo;
  final int metre;
  final int minute;
  final int targetStep;
  final int targetCalo;
  final int targetMetre;
  final int targetMinute;

  StepEntity({
    String? id,
    required this.userId,
    required this.date,
    this.step = 0,
    this.calo = 0,
    this.metre = 0,
    this.minute = 0,
    this.targetStep = 1,
    this.targetCalo = 1,
    this.targetMetre = 1,
    this.targetMinute = 1,
  }) : id = id ?? const Uuid().v4();

  StepEntity copyWith({
    DateTime? date,
    int? step,
    int? calo,
    int? metre,
    int? minute,
    int? targetStep,
    int? targetCalo,
    int? targetMetre,
    int? targetMinute,
  }) =>
      StepEntity(
        id: id,
        userId: userId,
        date: date ?? this.date,
        step: step ?? this.step,
        calo: calo ?? this.calo,
        metre: metre ?? this.metre,
        minute: minute ?? this.minute,
        targetStep: targetStep ?? this.targetStep, 
        targetCalo: targetCalo ?? this.calo,
        targetMetre: targetMetre ?? this.targetMetre,
        targetMinute: targetMinute ?? this.targetMinute,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': date,
        'step': step,
        'calo': calo,
        'metre': metre,
        'minute': minute,
      };

  factory StepEntity.fromJson(Map<String, dynamic> json) => StepEntity(
        id: json['id'],
        userId: json['user_id'],
        date: json['date'],
        step: json['step'],
        calo: json['calo'],
        metre: json['metre'],
        minute: json['minute'],
      );
}
