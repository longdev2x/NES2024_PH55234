import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/repositories/friend_repos.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/global.dart';

//Search Provider
class SearchFriendNotifier extends AutoDisposeAsyncNotifier<List<FriendEntityWithStatus>> {
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

    print('zzz-length-${getFriends.length}');

    //Lọc lấy status
    List<FriendEntityWithStatus> friendHaveStatus = getFriends.map((friend) {
      print('zzz-friend-${friend.friendId}');
      FriendshipEntity? friendShip;
      //Không dùng firstWhere do nó không trả về null được
      if (listFriendShip.isNotEmpty) {
        print('zzzNoNUll listFriendShipLength - ${listFriendShip.length}');
        for (FriendshipEntity frs in listFriendShip) {
          print('zzzNoNUll friendShipFrId - ${frs.friendId}');
                  print('zzzNoNUll getFriendId - ${friend.friendId}');
          print('zzzNoNUll listFriendShipLength - ${listFriendShip.length}');
          if (friend.friendId == frs.friendId ||
              friend.friendId == frs.userId) {
            print('zzzNoNUll - Have..');
            friendShip = frs;
            break;
          }
        }
      }
      print('zzzOK');
      if (friendShip == null) print('zzz - frs null');
      print('zzz-friendShip-${friendShip}');
      if (friendShip == null) {
        print('zzz-Ok come to null status');
        return FriendEntityWithStatus(friend: friend);
      } else {
        print('zzzNoNUll');
        print('zzzNoNUll-${friendShip.status}');
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

  Future<void> sendFriendRequest(String friendId, WidgetRef ref, String query) async {
    print('zzzzz--$query');
    final objUser = await ref.read(profileProvider.future);

    FriendshipEntity objFriendShip = FriendshipEntity(
        userId: Global.storageService.getUserId(),
        friendId: friendId,
        status: 'pending',
        senderUsername: objUser.username,
        senderAvatar: objUser.avatar,
        role: objUser.role,
        createdAt: DateTime.now());
    ref.read(searchProvider.notifier).searchFriends(query: query);
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
