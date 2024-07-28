import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SleepEntity {
  final String id;
  final String userId;
  final DateTime? planStartTime;
  final DateTime? startTime;
  final DateTime? endTime;

  SleepEntity({
    String? id,
    required this.userId,
    this.planStartTime,
    this.startTime,
    this.endTime,
  }) : id = id ?? const Uuid().v4();

  SleepEntity copyWith({
    DateTime? planStartTime,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      SleepEntity(
          id: id,
          userId: userId,
          planStartTime: planStartTime ?? this.planStartTime,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime,);

  factory SleepEntity.fromJson(Map<String, dynamic> json) {
    return SleepEntity(
      id: json['id'],
      userId: json['user_id'],
      startTime: json['start_time'] != null ? (json['start_time'] as Timestamp).toDate() : null,
      endTime: json['end_time'] != null ? (json['end_time'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_time': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'end_time': endTime != null ? Timestamp.fromDate(endTime!) : null,
    };
  }

  String? get planStartDateFormat {
    DateFormat format = DateFormat('HH-mm');
    return planStartTime != null ? format.format(planStartTime!) : '';
  }

  String? get startDateFormat {
    DateFormat format = DateFormat('HH:mm');
    return startTime != null ? format.format(startTime!) : '';
  }

  String? get endDateFormat {
    DateFormat format = DateFormat('HH:mm');
    return endTime != null ? format.format(endTime!) : '';
  }

  String get getDuration {
    int durationMinutes = endTime!.difference(startTime!).inMinutes ;
    if(durationMinutes < 60) {
      return '$durationMinutes phút'; 
    } else {
      return '${durationMinutes/60} giờ';
    }
  }
}
