import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';

class PostGratefulRepos {
  static const String _c = AppConstants.cPostGrateful;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;


  static Future<List<PostGratefulEntity>> getAllPosts() async {
    final snapshot = await _firestore.collection(_c).get();
    return snapshot.docs.map((e) => PostGratefulEntity.fromJson(e.data())).toList();
  }

  static Future<PostGratefulEntity> getPost(String id) async {
    final docRef = await _firestore.collection(_c).doc(id).get();
    if (docRef.exists) {
      return PostGratefulEntity.fromJson(docRef.data()!);
    } else {
      throw Exception('Post Not Found');
    }
  }

  static Future<void> createOrUpdatePost(PostGratefulEntity objPost) async {
    final docRef = _firestore.collection(_c).doc(objPost.id);
    final snapShot = await docRef.get();
    if(snapShot.exists) {
      docRef.update(objPost.toJson());
      return;
    }
    //Upload images and get link
    objPost = objPost.copyWith(
        contentItems: await _uploadImages(objPost.contentItems, objPost.id));
    await docRef.set(objPost.toJson());
  }

  static Future<List<ContentItem>> _uploadImages(
    List<ContentItem> items,
    String idPost,
  ) async {
    List<ContentItem> newItems = [];

    for (ContentItem item in items) {
      if (item.type == 'image') {
        //_storage.ref() là root của fbStorage, child sau là folder tổng, sau có thể tạo thêm folder không thì id
        final ref =
            _storage.ref().child(AppConstants.fbStoragePost).child(idPost);
        if (item.imageFile != null) {
          await ref.putFile(item.imageFile!);
          String url = await ref.getDownloadURL();
          item = item.copyWith(content: url);
        }
      }
      newItems.add(item);
    }
    return newItems;
  }
}
