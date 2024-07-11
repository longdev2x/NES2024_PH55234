import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TaskEntity {
  final String id;
  final String mainTask;
  final bool isDone;
  final List<String>? additionalTasks;
  final DateTime date;
  final DateTime? reminderDate;
  final String? repeat;
  final String? categoryId;
  final bool isFlag;

  TaskEntity({
    String? id,
    required this.mainTask,
    this.isDone = false,
    this.additionalTasks,
    required this.date,
    this.reminderDate,
    this.isFlag = false,
    this.repeat,
    this.categoryId,
  }) : id = id ?? const Uuid().v4();

  TaskEntity copyWith(
          {String? mainTask,
          bool? isDone = false,
          List<String>? additionalTasks,
          DateTime? date,
          DateTime? reminderDate,
          String? repeat,
          bool? isFlag = false,
          String? categoryId}) =>
      TaskEntity(
          id: id,
          mainTask: mainTask ?? this.mainTask,
          isDone: isDone ?? this.isDone,
          additionalTasks: additionalTasks ?? this.additionalTasks,
          date: date ?? this.date,
          reminderDate: reminderDate ?? this.reminderDate,
          repeat: repeat ?? this.repeat,
          isFlag: isFlag ?? this.isFlag,
          categoryId: categoryId ?? this.categoryId);

  factory TaskEntity.fromJson(Map<String, dynamic> json) => TaskEntity(
      id: json['id'],
      mainTask: json['main_task'],
      isDone: json['is_done'],
      additionalTasks: json['anditional_tasks'] != null
          ? List<String>.from(json['anditional_tasks'])
          : null,
      date: json['date'] != null
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
      reminderDate: json['reminder_date'] != null
          ? (json['reminder_date'] as Timestamp).toDate()
          : null,
      repeat: json['repeat'],
      isFlag: json['is_flag'] ?? false,
      categoryId: json['category_id']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'main_task': mainTask,
        'is_done': isDone,
        'anditional_tasks': additionalTasks,
        'date': date,
        'reminder_date': reminderDate,
        'repeat': repeat,
        'is_flag': isFlag,
        'category_id': categoryId
      };

  String get formatDateTime {
    final fomart = DateFormat("dd/MM - kk:mm");
    return fomart.format(date);
  }

    String get formatDate {
    final fomart = DateFormat("dd/MM");
    return fomart.format(date);
  }

  String get formatTime {
    final fomart = DateFormat("kk:mm");
    return fomart.format(date);
  }

  String get formatReminderTime {
    final fomart = DateFormat("kk:mm");
    return fomart.format(reminderDate ?? DateTime(date.minute + 5));
  }
}
