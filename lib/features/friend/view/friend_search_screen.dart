import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_search_bar.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_provider.dart';
import 'package:nes24_ph55234/features/friend/view/friend_widgets.dart';

class FriendSearchScreen extends ConsumerWidget {
  static String query = '';
  const FriendSearchScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchListHaveStatus = ref.watch(searchProvider);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: AppSearchBar(
            onChanged: (textQuery) {
              query = textQuery;
              print('zzzzz textQuey $textQuery');
              print('zzzzz query $query');
              _onSearch(textQuery, ref);
            },
            focus: true,
            hintText: 'Tìm bạn bè',
            haveIcon: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.marginVeti,
          horizontal: AppConstants.marginHori,
        ),
        child: fetchListHaveStatus.when(
          data: (listFriendsHaveStatus) {
            print('zzzzz -before com -$query');
            return _buildContent(
              query: query,
              ref: ref,
              context: context,
              listFriendsHaveStatus: listFriendsHaveStatus,
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text('Lỗi khi tìm kiếm bạn bè - $error'));
          },
          loading: () => const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildContent({
    required String query,
    required WidgetRef ref,
    required BuildContext context,
    required List<FriendEntityWithStatus> listFriendsHaveStatus,
  }) {
    return ListView.builder(
      itemCount: listFriendsHaveStatus.length,
      itemBuilder: (context, index) {
        final FriendEntity objFriend = listFriendsHaveStatus[index].friend;
        return ItemListFriendSearch(
          objFriendWithStatus: listFriendsHaveStatus[index],
          onTapRow: () {
            Navigator.pushNamed(context, AppRoutesNames.friendProfile,
                arguments: listFriendsHaveStatus[index]);
          },
          onTapAdd: () {
            print('zzzzz-come query-$query');
            print('zzzOk send - ${listFriendsHaveStatus[index].friend.username}');
            _sendFriendRequest(
                ref, listFriendsHaveStatus[index].friend.friendId, query);
          },
          onAcceptFriend: () {
            _acceptFriendRequest(objFriend.friendId, ref);
          },
          onNotAcceptFriend: () {
            _rejectFriendRequest(objFriend.friendId, ref);
          },
        );
      },
    );
  }

  void _onSearch(String query, WidgetRef ref) async {
    if (query.isNotEmpty) {
      ref
          .read(searchProvider.notifier)
          .searchFriends(query: query, isEmail: query.contains('@gmail.com'));
    }
  }

  void _sendFriendRequest(WidgetRef ref, String friendId, String query) {
    ref.read(friendshipProvider.notifier).sendFriendRequest(friendId, ref, query);
  }

  void _acceptFriendRequest(String friendshipId, WidgetRef ref) {
    ref.read(friendshipProvider.notifier).acceptFriendRequest(friendshipId);
  }

  void _rejectFriendRequest(String friendshipId, WidgetRef ref) {
    ref.read(friendshipProvider.notifier).rejectFriendRequest(friendshipId);
  }
}
