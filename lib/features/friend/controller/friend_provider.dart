import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/repositories/friend_repos.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/global.dart';

//Search Provider
class SearchFriendNotifier
    extends AutoDisposeAsyncNotifier<List<FriendEntity>> {
  SearchFriendNotifier();
  @override
  FutureOr<List<FriendEntity>> build() async {
    return [];
  }

  searchFriends({
    String? query,
    bool isEmail = false,
  }) async {
    state = AsyncValue.data(
      await FriendRepos.searchUsers(
        query ?? '',
        isEmail: isEmail,
      ),
    );
  }
}

final searchProvider =
    AutoDisposeAsyncNotifierProvider<SearchFriendNotifier, List<FriendEntity>>(
        () {
  return SearchFriendNotifier();
});
//get trang friend profile
final friendProfileProvider = FutureProvider.family<List<FriendEntity>, String>((ref, query) async {
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
