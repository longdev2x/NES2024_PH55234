import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_search_bar.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_provider.dart';
import 'package:nes24_ph55234/features/friend/view/friend_widgets.dart';

class FriendSearchScreen extends ConsumerWidget {
  const FriendSearchScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.watch(searchProvider);
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: AppSearchBar(
              onChanged: (query) {
                _onSearch(query, ref);
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
          child: fetchList.when(
            data: (listFriends) {
              return _buildContent(
                ref: ref,
                context: context,
                listFriends: listFriends,
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
    required WidgetRef ref,
    required BuildContext context,
    required List<FriendEntity> listFriends,
  }) {
    return ListView.builder(
      itemCount: listFriends.length,
      itemBuilder: (context, index) {
        return ItemListFriend(
          objFriend: listFriends[index],
          onTapRow: () {
            Navigator.pushNamed(context, AppRoutesNames.friendProfile, arguments: listFriends[index].username);
          },
          onTapAdd: () {
            _sendFriendRequest(ref, listFriends[index].friendId);
          },
        );
      },
    );
  }

  void _onSearch(String query, WidgetRef ref) async {
    if (query.isNotEmpty) {
      ref.read(searchProvider.notifier).searchFriends(query: query, isEmail: query.contains('@gmail.com'));
    }
  }

  void _sendFriendRequest(WidgetRef ref,String friendId) {
    ref.read(friendshipProvider.notifier).sendFriendRequest(friendId, ref);
  }
}
