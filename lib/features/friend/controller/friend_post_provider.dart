import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/repositories/post_friend_repos.dart';
import 'package:nes24_ph55234/global.dart';

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
        if (newPost == null) {
          listPost.insert(0, objPost);
        }
        return listPost;
      },
    );
    await PostFriendRepos.createOrUpdateFriendPost(newPost ?? objPost);
    state = await AsyncValue.guard(() async => await _loadList());
  }

  Future<void> toggleLike(String postId) async {
    final userId = Global.storageService.getUserId();

    state = state.whenData((posts) {
      return posts.map((post) {
        if (post.id == postId) {
          final newLikes = List<String>.from(post.likes);
          if (newLikes.contains(userId)) {
            newLikes.remove(userId);
          } else {
            newLikes.add(userId);
          }
          return post.copyWith(likes: newLikes);
        }
        return post;
      }).toList();
    });
    // Cập nhật trên server
    await PostFriendRepos.updatePostLikes(
        postId, state.value!.firstWhere((post) => post.id == postId).likes);
  }

  Future<void> addComment(String postId) async {
    state = state.whenData((posts) {
      return posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(commentCount: post.commentCount + 1);
        }
        return post;
      }).toList();
    });

    // Cập nhật trên server
    await PostFriendRepos.updatePostCommentCount(postId,
        state.value!.firstWhere((post) => post.id == postId).commentCount);
  }
}

final friendPostProvider =
    AsyncNotifierProvider<FriendPostNotifier, List<PostFriendEntity>>(
  () => FriendPostNotifier(),
);


final profilePostProvider = FutureProvider.family<List<PostFriendEntity>, String>((ref, friendId) {
  return PostFriendRepos.getFriendPostsByUser(friendId);
},);