import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
class VideoEntity {
  final String id;
  final String? userId;
  final String? type;
  final String? title;
  final String? url;
  final String? thumbnail;
  final File? fileVideo;
  final File? fileImage;
  final String? des;
  final DateTime updateAt;

  VideoEntity({
    String? id,
    this.type,
    this.url,
    this.userId,
    this.title,
    this.thumbnail,
    this.fileImage,
    this.fileVideo,
    this.des,
    required this.updateAt,
  }) : id = const Uuid().v4();

  VideoEntity copyWith({
    String? url,
    String? thumbnail,
  }) =>
      VideoEntity(
          id: id,
          userId: userId,
          type: type,
          des: des,
          thumbnail: thumbnail ?? this.thumbnail,
          title: title,
          url: url ?? this.url,
          updateAt: updateAt);

  factory VideoEntity.fromJson(Map<String, dynamic> json) => VideoEntity(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        url: json['url'],
        thumbnail: json['thumbnail'],
        title: json['title'],
        des: json['des'],
        updateAt: (json['updateAt'] as Timestamp).toDate()
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'url': url,
        'user_id': userId,
        'title': title,
        'thumbnail': thumbnail,
        'des': des,
        'updateAt' : Timestamp.fromDate(updateAt),
      };
}