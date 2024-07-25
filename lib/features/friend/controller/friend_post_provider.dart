import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/repositories/post_friend_repos.dart';

class FriendPostNotifier extends AsyncNotifier<List<PostFriendEntity>> {
  @override
  FutureOr<List<PostFriendEntity>> build() {
    return _loadList();
  }

  Future<List<PostFriendEntity>> _loadList() async {
    return await PostFriendRepos.getAllPosts();
  }

  Future<void> createOrUpdatePost(PostFriendEntity objPost) async {
    PostFriendEntity? newPost;
    state = state.whenData(
      (listPost) {
        listPost = listPost.map((post) {
          if (post.id == objPost.id) {
            post = objPost;
            newPost = post;
          }
          return post;
        }).toList();
        return listPost;
      },
    );
    await PostFriendRepos.createOrUpdateFriendPost(newPost ?? objPost);
    state = await AsyncValue.guard(() async => await _loadList());
  }
}

final friendPostProvider =
    AsyncNotifierProvider<FriendPostNotifier, List<PostFriendEntity>>(
  () => FriendPostNotifier(),
);
