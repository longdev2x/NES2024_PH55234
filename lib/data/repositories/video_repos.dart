import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';

class VideoRepos {
  static final FirebaseFirestore _insFirestore = FirebaseFirestore.instance;
  static final FirebaseStorage _insStorage = FirebaseStorage.instance;
  static const String _c = AppConstants.cVideo;

  static Future<List<VideoEntity>> getAllVideo() async {
    final docRef = await _insFirestore.collection(_c).get();
    return docRef.docs
        .map((data) => VideoEntity.fromJson(data.data()))
        .toList();
  }

  static Future<void> uploadVideo(VideoEntity objVideo) async {
    final ImagePicker picker = ImagePicker();
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      if (videoFile != null) {
        UploadTask uploadVideoTask = _insStorage
            .ref()
            .child(AppConstants
                .fbStorageAllVideo) // Folder chứa toàn bộ video mọi user
            .child(objVideo.id) // id của mỗi video
            .putFile(
              File(videoFile.path), // chỉ nhận File, source máy trả về XFile
            );
        TaskSnapshot snapshot = await uploadVideoTask;
        String url = await snapshot.ref.getDownloadURL();
        objVideo = objVideo.copyWith(url: url);

        //To Firestore
        final docRef = _insFirestore.collection(AppConstants.cVideo).doc(objVideo.id);
        await docRef.set(objVideo.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error video picker');
      }
    }
  }
}
