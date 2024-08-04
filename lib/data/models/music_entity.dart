import 'package:uuid/uuid.dart';

class MusicEntity {
  final String id;
  final String title;
  final String url;

  MusicEntity({
    String? id,
    required this.title,
    required this.url,
  }) : id = id ?? const Uuid().v4();

  factory MusicEntity.fromJson(Map<String, dynamic> json) {
    return MusicEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
    };
  }
}
