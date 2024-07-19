import 'package:cloud_firestore/cloud_firestore.dart';

enum PostFeel { happy, sad, normal}
enum PostType { gratetul, normal}
enum PostLimit { private, public }

class PostEntity {
  final String id;
  final String userId;
  final PostFeel? feel;
  final PostLimit? limit;
  final PostType? type;
  final String? title;
  final String? content;
  final DateTime? date;
  final List<String>? images;

  PostEntity(
      {required this.id,
      required this.userId,
      required this.limit,
      required this.title,
      this.type,
      required this.content,
      required this.date,
      required this.feel,
      this.images});

  PostEntity copyWith({
    PostLimit? limit,
    PostFeel? feel,
    PostType? type,
    String? title,
    String? content,
    DateTime? date,
    List<String>? images,
  }) =>
      PostEntity(
        id: id,
        userId: userId,
        limit: limit ?? this.limit,
        type: type ?? this.type,
        title: title ?? this.title,
        content: content ?? this.content,
        feel: feel ?? this.feel,
        images: images ?? this.images,
        date: date,
      );

  factory PostEntity.fromJson(Map<String, dynamic> json) => PostEntity(
        id: json['id'],
        userId: json['user_id'],
        limit: PostLimit.values.where((e) => e.name == json['limit']).first,
        type: PostType.values.where((e) => e.name == json['type']).first,
        title: json['title'],
        content: json['content'],
        feel: PostFeel.values.where((e) => e.name == json['feel']).first,
        images: json['images'] as List<String>,
        date: (json['date'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'user_id' : userId,
    'limit' : limit.toString().split('.').last,
    //Ví dụ Feel.good => ['Feel', 'good'].last
    'feel' : feel.toString().split('.').last,
    'type' : type.toString().split('.').last,
    'title' : title,
    'content': content,
    'images' : images,
    'date' : date
  };
}
