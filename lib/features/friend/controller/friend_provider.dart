import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/repositories/friend_repos.dart';
import 'package:nes24_ph55234/global.dart';

final userSearchProvider =
    FutureProvider.family<List<FriendEntity>, SearchParams>(
        (ref, params) async {
  return FriendRepos.searchUsers(params.query, isEmail: params.isEmail);
});

final friendRequestsProvider = StreamProvider<List<FriendshipEntity>>((ref) {
  final stream = FriendRepos.getFriendRequests(
      Global.storageService.getUserId());
  return stream;
});

final friendsProvider = StreamProvider<List<FriendEntity>>((ref) {
  return FriendRepos.getFriends(Global.storageService.getUserId());
});

class FriendshipNotifier extends StateNotifier<AsyncValue<void>> {
  FriendshipNotifier() : super(const AsyncValue.data(null));

  Future<void> sendFriendRequest(String friendId) async {
    FriendshipEntity objFriendShip = FriendshipEntity(
        userId: Global.storageService.getUserId(),
        friendId: friendId,
        status: 'pending',
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
      state = const AsyncValue.data(null);
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
