import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TargetEntity {
  final String id;
  final String userId;
  final String type;
  final String target;
  final DateTime? dateStart;
  final DateTime? dateEnd;

  TargetEntity({
    String? id,
    required this.userId,
    required this.type,
    required this.target,
    required this.dateStart,
    required this.dateEnd,
  }) : id = id ?? const Uuid().v4();

  TargetEntity copyWith({
    String? type,
    String? target,
    DateTime? dateStart,
    DateTime? dateEnd,
  }) =>
      TargetEntity(
        id: id,
        userId: userId,
        type: type ?? this.type,
        target: target ?? this.target,
        dateStart: dateStart ?? this.dateStart,
        dateEnd: dateEnd ?? this.dateEnd,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'type': type,
        'target': target,
        'date_start': dateStart,
        'date_end': dateEnd,
      };

  factory TargetEntity.fromJson(Map<String, dynamic> json) => TargetEntity(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        target: json['target'],
        dateStart: json['date_start'] != null
          ? (json['date_end'] as Timestamp).toDate()
          : null,
        dateEnd: json['date_end'] != null
          ? (json['date_end'] as Timestamp).toDate()
          : null,
      );
}
