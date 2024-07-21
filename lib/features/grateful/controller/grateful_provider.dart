import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/data/repositories/post_repos.dart';

class GratefulNotifier extends AutoDisposeAsyncNotifier<List<PostEntity>> {
  @override
  FutureOr<List<PostEntity>> build() {
    return _loadList();
  }
  Future<List<PostEntity>> _loadList() async {
    return PostRepos.getPostsType(PostType.gratetul);
  }

  Future<void> createPost(PostEntity objPost) async {
    PostRepos.createPost(objPost);
  }
}

final gratefulProvider =
    AutoDisposeAsyncNotifierProvider<GratefulNotifier, List<PostEntity>>(
  () => GratefulNotifier(),
);
