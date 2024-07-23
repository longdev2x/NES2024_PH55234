import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/global.dart';

class CreatePostNotifer extends StateNotifier<PostEntity> {
  CreatePostNotifer()
      : super(
          PostEntity(
              userId: Global.storageService.getUserProfile().id,
              limit: PostLimit.private,
              title: '',
              contentItems: [],
              date: DateTime.now(),
              feel: PostFeel.normal,
              type: PostType.gratetul),
        );
  void updateState({
    PostLimit? limit,
    String? title,
    List<ContentItem>? contentItems,
    PostFeel? feel,
    DateTime? date,
  }) {
    state = state.copyWith(
      limit: limit,
      title: title,
      contentItems: contentItems,
      feel: feel,
      date: date,
    );
  }

  void reset() {
    state = PostEntity(
        userId: Global.storageService.getUserProfile().id,
        limit: PostLimit.private,
        title: '',
        contentItems: [],
        date: DateTime.now(),
        feel: PostFeel.normal,
        type: PostType.gratetul);
  }
  
  void initEdit(PostEntity objPost) {
    state = objPost;
  }
}

final createPostGratefulProvider =
    StateNotifierProvider<CreatePostNotifer, PostEntity>(
        (ref) => CreatePostNotifer());
