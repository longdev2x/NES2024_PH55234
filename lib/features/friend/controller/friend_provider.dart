import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/repositories/friend_repos.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/global.dart';

//Search Provider
class SearchFriendNotifier
    extends AutoDisposeAsyncNotifier<List<FriendEntityWithStatus>> {
  List<FriendshipEntity> listFriendShip = [];
  SearchFriendNotifier();
  @override
  FutureOr<List<FriendEntityWithStatus>> build() async {
    listFriendShip = ref.watch(checkFriendStatusProvider).valueOrNull ?? [];
    return [];
  }

  searchFriends({
    String? query,
    bool isEmail = false,
  }) async {
    List<FriendEntity> getFriends = await FriendRepos.searchUsers(
      query ?? '',
      isEmail: isEmail,
    );

    String currentUserId = Global.storageService.getUserId();
    //Lọc lấy status
    List<FriendEntityWithStatus> friendHaveStatus = getFriends.map((friend) {
      FriendshipEntity? friendShip = listFriendShip.isEmpty
          ? null
          : listFriendShip.firstWhere((friendShip) =>
              (friendShip.userId == currentUserId &&
                  friendShip.friendId == friend.friendId) ||
              (friendShip.friendId == currentUserId &&
                  friendShip.userId == friend.friendId));
      if (friendShip == null) {
        return FriendEntityWithStatus(friend: friend);
      } else {
        return FriendEntityWithStatus(
            friend: friend, status: friendShip.status);
      }
    }).toList();

    state = AsyncValue.data(friendHaveStatus);
  }
}

final searchProvider = AutoDisposeAsyncNotifierProvider<SearchFriendNotifier,
    List<FriendEntityWithStatus>>(
  () => SearchFriendNotifier(),
);
//Stream xem đã gửi lời mời chưa, có lời mời rồi, xử lý trạng thái nút kết bạn
final checkFriendStatusProvider = StreamProvider<List<FriendshipEntity>>((ref) {
  final stream = FriendRepos.checkFriendShipStatus(
    Global.storageService.getUserId(),
  );
  return stream;
});

//get trang friend profile
final friendProfileProvider =
    FutureProvider.family<List<FriendEntity>, String>((ref, query) async {
  return FriendRepos.searchUsers(query);
});

//Stream friendships
final friendRequestsProvider = StreamProvider<List<FriendshipEntity>>((ref) {
  final stream = FriendRepos.getFriendRequests(
    Global.storageService.getUserId(),
  );
  return stream;
});
//Stream user (ListFriends),
final friendsProvider = StreamProvider<List<FriendEntity>>((ref) {
  return FriendRepos.getFriends(Global.storageService.getUserId());
});

//FriendShip
class FriendshipNotifier extends StateNotifier<AsyncValue<void>> {
  FriendshipNotifier() : super(const AsyncValue.data(null));

  Future<void> sendFriendRequest(String friendId, WidgetRef ref) async {
    final objUser = await ref.read(profileProvider.future);

    FriendshipEntity objFriendShip = FriendshipEntity(
        userId: Global.storageService.getUserId(),
        friendId: friendId,
        status: 'pending',
        senderUsername: objUser.username,
        senderAvatar: objUser.avatar,
        role: objUser.role,
        createdAt: DateTime.now());
    try {
      await FriendRepos.sendFriendRequest(objFriendShip);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> acceptFriendRequest(String friendshipId) async {
    try {
      await FriendRepos.acceptFriendRequest(friendshipId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> rejectFriendRequest(String friendshipId) async {
    try {
      await FriendRepos.rejectFriendRequest(friendshipId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final friendshipProvider =
    StateNotifierProvider<FriendshipNotifier, AsyncValue<void>>((ref) {
  return FriendshipNotifier();
});

class SearchParams {
  final String query;
  final bool isEmail;

  const SearchParams(this.query, this.isEmail);
}
