import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';

class MusicRepos {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _c = AppConstants.cMusic;

  static Future<List<VideoEntity>> getAllVideo() async {
    final docRef = await _instance.collection(_c).get();
    return docRef.docs.map((data) => VideoEntity.fromJson(data.data())).toList();
  }
}