import 'package:uuid/uuid.dart';

class VideoEntity {
  final String id;
  final String? userId;
  final String? type;
  final String? url;
  final String? title;
  final String? thumbnail;
  final String? des;

  VideoEntity({
    String? id,
    this.type,
    this.url,
    this.userId,
    this.title,
    this.thumbnail,
    this.des,
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
          url: url ?? this.url);

  factory VideoEntity.fromJson(Map<String, dynamic> json) => VideoEntity(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        url: json['url'],
        thumbnail: json['thumbnail'],
        title: json['title'],
        des: json['des'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'url': url,
        'user_id': userId,
        'title': title,
        'thumbnail': thumbnail,
        'des': des,
      };
}

// class VideoControlEntity {
//   final String? url;
//   final bool isPlayed;
//   final double volume;
//   final bool isFullScreen;
//   final Future<void>? initVideo;

//   VideoControlEntity(
//       {this.url,
//       this.isPlayed = false,
//       this.volume = 1,
//       this.isFullScreen = false,
//       this.initVideo});

//   VideoControlEntity copyWith({
//     String? url,
//     bool? isPlayed,
//     double? volume,
//     bool? isFullScreen,
//     Future<void>? initVideo,
//   }) =>
//       VideoControlEntity(
//         url: url ?? this.url,
//         isPlayed: isPlayed ?? this.isPlayed,
//         volume: volume ?? this.volume,
//         isFullScreen: isFullScreen ?? this.isFullScreen,
//         initVideo: initVideo ?? this.initVideo,
//       );
// }
