import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:uuid/uuid.dart';

enum PostFeel { happy, sad, normal, angry, haha, cry }

enum PostType { gratetul, normal }

enum PostLimit { private, public }

class ContentItem {
  final String type; // 'text' hoặc 'image'
  final String? content; // Nội dung văn bản hoặc URL của hình ảnh
  final File? imageFile;

  ContentItem({required this.type, this.content, this.imageFile});

  ContentItem copyWith({String? content}) => ContentItem(
      type: type, content: content ?? this.content, imageFile: imageFile);

  Map<String, dynamic> toJson() => {
        'type': type,
        'content': content,
      };

  factory ContentItem.fromJson(Map<String, dynamic> json) => ContentItem(
        type: json['type'],
        content: json['content'],
      );
}

//icon pas
Map<PostFeel, String> emoijMap = {
  PostFeel.normal: ImageRes.icNormar,
  PostFeel.angry: ImageRes.icAngry,
  PostFeel.cry: ImageRes.icCry,
  PostFeel.haha: ImageRes.icHaha,
  PostFeel.sad: ImageRes.icSad,
  PostFeel.happy: ImageRes.icHappy,
};

class PostEntity {
  final String id;
  final String userId;
  final List<ContentItem> contentItems;
  final PostFeel? feel;
  final PostLimit? limit;
  final PostType? type;
  final String? title;
  final DateTime? date;

  PostEntity({
    String? id,
    required this.contentItems,
    required this.userId,
    required this.limit,
    required this.title,
    required this.type,
    required this.date,
    required this.feel,
  }) : id = const Uuid().v4();

  PostEntity copyWith({
    PostLimit? limit,
    PostFeel? feel,
    String? title,
    DateTime? date,
    List<ContentItem>? contentItems,
  }) =>
      PostEntity(
        contentItems: contentItems ?? this.contentItems,
        id: id,
        userId: userId,
        limit: limit ?? this.limit,
        title: title ?? this.title,
        feel: feel ?? this.feel,
        type: type,
        date: date ?? this.date,
      );

  factory PostEntity.fromJson(Map<String, dynamic> json) => PostEntity(
        id: json['id'],
        userId: json['user_id'],
        contentItems: (json['content_items'] as List)
            .map((item) => ContentItem.fromJson(item))
            .toList(),
        limit: PostLimit.values.where((e) => e.name == json['limit']).first,
        type: PostType.values.where((e) => e.name == json['type']).first,
        title: json['title'],
        feel: PostFeel.values.where((e) => e.name == json['feel']).first,
        date: (json['date'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'content_items': contentItems.map((e) => e.toJson()).toList(),
        'limit': limit.toString().split('.').last,
        //Ví dụ Feel.good => ['Feel', 'good'].last
        'feel': feel.toString().split('.').last,
        'type': type.toString().split('.').last,
        'title': title,
        'date': date
      };
}
