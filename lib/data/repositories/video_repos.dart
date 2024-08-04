import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';

class VideoRepos {
  static final FirebaseFirestore _insFirestore = FirebaseFirestore.instance;
  static final FirebaseStorage _insStorage = FirebaseStorage.instance;
  static const String _c = AppConstants.cVideo;

  static Future<List<VideoEntity>> getAllVideo() async {
    try {
      final docRef =
          await _insFirestore.collection(_c).orderBy('updateAt').get();
      return docRef.docs
          .map((data) => VideoEntity.fromJson(data.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> uploadVideo(VideoEntity objVideo) async {
    if (objVideo.fileImage == null || objVideo.fileVideo == null) return;
    try {
      objVideo = objVideo.copyWith(
          url: await _storeAndgetLinkVideo(objVideo, 'video'));
      objVideo = objVideo.copyWith(
          thumbnail: await _storeAndgetLinkVideo(objVideo, ''));
      //To Firestore
      final docRef =
          _insFirestore.collection(AppConstants.cVideo).doc(objVideo.id);
      await docRef.set(objVideo.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error video picker');
      }
    }
  }

  static Future<String> _storeAndgetLinkVideo(
      VideoEntity objVideo, String type) async {
    UploadTask uploadVideoTask = _insStorage
        .ref()
        .child(AppConstants.fbStorageAllVideo)
        .child(objVideo.id)
        .putFile(type == 'video' ? objVideo.fileVideo! : objVideo.fileImage!);
    TaskSnapshot snapshot = await uploadVideoTask;
    return await snapshot.ref.getDownloadURL();
  }
}
