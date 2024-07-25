import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';

class PostFriendRepos {
  static const String _c = AppConstants.cPostFriend;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<List<PostFriendEntity>> getAllPosts() async {
    final snapshot = await _firestore.collection(_c).get();
    return snapshot.docs.map((e) => PostFriendEntity.fromJson(e.data())).toList();
  }

  static Future<List<PostFriendEntity>> getFriendPostsByUser(String userId) async {
    final snapshot = await _firestore
        .collection(_c)
        .where('user_id', isEqualTo: userId)
        .get();
    return snapshot.docs.map((e) => PostFriendEntity.fromJson(e.data())).toList();
  }

  static Future<PostFriendEntity> getFriendPost(String id) async {
    final docRef = await _firestore.collection(_c).doc(id).get();
    if (docRef.exists) {
      return PostFriendEntity.fromJson(docRef.data()!);
    } else {
      throw Exception('Không tìm thấy bài viết bạn bè');
    }
  }

  static Future<void> createOrUpdateFriendPost(PostFriendEntity objPost) async {
    final docRef = _firestore.collection(_c).doc(objPost.id);
    final snapShot = await docRef.get();
    
    // Upload images and get links
    List<String?> uploadedImages = await _uploadImages(objPost.imageFiles, objPost.id);
    objPost = objPost.copyWith(images: uploadedImages, imageFiles: []);

    if(snapShot.exists) {
      await docRef.update(objPost.toJson());
    } else {
      await docRef.set(objPost.toJson());
    }
  }

  static Future<List<String?>> _uploadImages(
    List<File?> imageFiles,
    String idPost,
  ) async {
    List<String?> imageUrls = [];

    for (File? file in imageFiles) {
      if (file != null) {
        final ref = _storage.ref().child(AppConstants.fbStoragePost).child(idPost).child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      } else {
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

}