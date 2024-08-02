import 'package:uuid/uuid.dart';

class NotifyEntity {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime time;
  final bool isRead;

  NotifyEntity({
    String? id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
  }) : id = id ?? const Uuid().v4();
}