import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/repositories/post_repos.dart';

class GratefulNotifier extends AsyncNotifier<List<PostEntity>> {
  @override
  FutureOr<List<PostEntity>> build() {
    return _loadList();
  }

  Future<List<PostEntity>> _loadList() async {
    return await PostRepos.getPostsType(PostType.gratetul);
  }

  Future<void> createOrUpdatePost(PostEntity objPost) async {
    PostEntity? newPost;
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
    await PostRepos.createOrUpdatePost(newPost ?? objPost);
    state = await AsyncValue.guard(() async => await _loadList());
  }
}

final gratefulProvider =
    AsyncNotifierProvider<GratefulNotifier, List<PostEntity>>(
  () => GratefulNotifier(),
);
