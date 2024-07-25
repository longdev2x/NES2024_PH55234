import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

class PostGratefulEntity {
  final String id;
  final String userId;
  final List<ContentItem> contentItems;
  final PostFeel? feel;
  final PostLimit? limit;
  final PostType? type;
  final String? title;
  final DateTime? date;

  PostGratefulEntity({
    String? id,
    required this.contentItems,
    required this.userId,
    required this.limit,
    required this.title,
    required this.type,
    required this.date,
    required this.feel,
  }) : id = id ?? const Uuid().v4();

  PostGratefulEntity copyWith({
    PostLimit? limit,
    PostFeel? feel,
    String? title,
    DateTime? date,
    List<ContentItem>? contentItems,
  }) =>
      PostGratefulEntity(
        contentItems: contentItems ?? this.contentItems,
        id: id,
        userId: userId,
        limit: limit ?? this.limit,
        title: title ?? this.title,
        feel: feel ?? this.feel,
        type: type,
        date: date ?? this.date,
      );

  factory PostGratefulEntity.fromJson(Map<String, dynamic> json) =>
      PostGratefulEntity(
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

  String get formatDate {
    final fomart = DateFormat("dd/MM/yyyy");
    return fomart.format(date ?? DateTime.now());
  }
}

class PostFriendEntity {
  final String id;
  final String userId;
  final String username;
  final String? avatar;
  final String content;
  final PostLimit limit;
  final List<String?> images;
  final List<File?> imageFiles;
  final PostFeel? feel;
  final PostType? type;
  final DateTime date;

  PostFriendEntity({
    String? id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.images,
    required this.imageFiles,
    required this.limit,
    required this.content,
    required this.type,
    required this.date,
    required this.feel,
  }) : id = id ?? const Uuid().v4();

  PostFriendEntity copyWith({
    String? content,
    PostLimit? limit,
    List<String?>? images,
    List<File?>? imageFiles,
    PostFeel? feel,
  }) =>
      PostFriendEntity(
        id: id,
        userId: userId,
        username: username,
        avatar: avatar,
        limit: limit ?? this.limit,
        content: content ?? this.content,
        feel: feel ?? this.feel,
        type: type,
        date: date,
        images: images ?? this.images,
        imageFiles: imageFiles ?? this.imageFiles,
      );

  factory PostFriendEntity.fromJson(Map<String, dynamic> json) {
    return PostFriendEntity(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      avatar: json['avatar'],
      content: json['content'],
      limit: PostLimit.values.firstWhere(
        (e) => e.name == json['limit'],
        orElse: () => PostLimit.public, // Default value if not found
      ),
      images: List<String?>.from(json['images'] ?? []),
      imageFiles: [], // Cannot be stored in JSON, initialize as empty
      type: PostType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PostType.normal, // Default value if not found
      ),
      date: (json['date'] as Timestamp).toDate(),
      feel: json['feel'] != null
          ? PostFeel.values.firstWhere(
              (e) => e.name == json['feel'],
              orElse: () => PostFeel.normal, // Default value if not found
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'avatar': avatar,
      'content': content,
      'limit': limit.name,
      'images': images,
      'type': type?.name,
      'date': Timestamp.fromDate(date),
      'feel': feel?.name,
    };
  }

  String get formatDate {
    final fomart = DateFormat("dd/MM/yyyy");
    return fomart.format(date);
  }
}
