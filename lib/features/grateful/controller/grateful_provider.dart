import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/repositories/post_grateful_repos.dart';

class GratefulNotifier extends AsyncNotifier<List<PostGratefulEntity>> {
  @override
  FutureOr<List<PostGratefulEntity>> build() {
    return _loadList();
  }

  Future<List<PostGratefulEntity>> _loadList() async {
    return await PostGratefulRepos.getAllPosts();
  }

  Future<void> createOrUpdatePost(PostGratefulEntity objPost) async {
    PostGratefulEntity? newPost;
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
    await PostGratefulRepos.createOrUpdatePost(newPost ?? objPost);
    state = await AsyncValue.guard(() async => await _loadList());
  }
}

final gratefulProvider =
    AsyncNotifierProvider<GratefulNotifier, List<PostGratefulEntity>>(
  () => GratefulNotifier(),
);
