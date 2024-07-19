import 'package:uuid/uuid.dart';

class MusicEntity {
  final String id;
  final String type;
  final String? title;

  MusicEntity({
    String? id,
    required this.type,
    this.title,
  }) : id = const Uuid().v4();

  factory MusicEntity.fromJson(Map<String, dynamic> json) => MusicEntity(
        id: json['id'],
        type: json['type'],
        title: json['title']
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
      };
}
