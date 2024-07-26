import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/models/message_entity.dart';
import 'package:nes24_ph55234/data/repositories/message_repos.dart';
import 'package:nes24_ph55234/global.dart';

//St123456ream danh sách chat
final chatProvider = StreamProvider.autoDispose<List<ChatEntity>>((ref) {
  final userId = Global.storageService.getUserId();
  return MessageRepos.getChats(userId);
});

// Provider để tạo chat mới
final createChatProvider =
    FutureProvider.family<void, FriendEntity>((ref, objFriend) async {
  final userId = Global.storageService.getUserId();
  await MessageRepos.createChat(ChatEntity(
      userId: userId,
      partnerId: objFriend.friendId,
      lastMsg: '',
      time: DateTime.now(),
      partnerUsername: objFriend.username,
      partnerAvatar: objFriend.avatar));
});
