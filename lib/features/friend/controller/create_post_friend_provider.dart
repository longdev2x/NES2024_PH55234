import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:uuid/uuid.dart';

class FriendCreatePostNotifier extends StateNotifier<PostFriendEntity> {
  late UserEntity objUser;
  FriendCreatePostNotifier({required this.objUser})
      : super(
          PostFriendEntity(
            id: const Uuid().v4(),
            userId: Global.storageService.getUserId(),
            username: objUser.username,
            avatar: objUser.avatar,
            limit: PostLimit.public,
            content: '',
            images: [],
            imageFiles: [],
            date: DateTime.now(),
            feel: PostFeel.normal,
            type: PostType.normal,
          ),
        );

  void updateState({
    String? content,
    PostLimit? limit,
    List<String?>? images,
    List<File?>? imageFiles,
    PostFeel? feel,
  }) {
    state = state.copyWith(
      content: content,
      limit: limit,
      images: images,
      imageFiles: imageFiles,
      feel: feel,
    );
  }

  void reset() {
    state = PostFriendEntity(
      id: const Uuid().v4(),
      userId: Global.storageService.getUserId(),
      username: objUser.username,
      avatar: objUser.avatar,
      limit: PostLimit.public,
      content: '',
      images: [],
      imageFiles: [],
      date: DateTime.now(),
      feel: PostFeel.normal,
      type: PostType.normal,
    );
  }

  void initEdit(PostFriendEntity objPost) {
    state = objPost;
  }

  void addImage(File image) {
    state = state.copyWith(
      imageFiles: [...state.imageFiles, image],
    );
  }

  void removeImage(int index) {
    List<File?> newImageFiles = List.from(state.imageFiles);
    newImageFiles.removeAt(index);
    state = state.copyWith(imageFiles: newImageFiles);
  }
}

final friendCreatePostProvider =
    StateNotifierProvider.family<FriendCreatePostNotifier, PostFriendEntity, UserEntity>(
        (ref, objUser) => FriendCreatePostNotifier(objUser: objUser));