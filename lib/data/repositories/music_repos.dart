import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/music_entity.dart';

class MusicRepos {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _c = AppConstants.cMusic;

  static Future<List<MusicEntity>> getMusicList() async {
    try {
      final snapshot = await _firestore.collection(_c).get();
      return snapshot.docs
          .map((doc) => MusicEntity.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Lỗi load nhạc: $e');
    }
  }

  static Future<String> uploadAudio(File audioFile, String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref('music/$fileName');
      final uploadTask = ref.putFile(audioFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> saveMusicInfo(MusicEntity music) async {
    try {
      await _firestore.collection(_c).doc(music.id).set(music.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }
}
