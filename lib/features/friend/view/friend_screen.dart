import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/features/friend/controller/chat_provider.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_provider.dart';
import 'package:nes24_ph55234/features/friend/view/friend_widgets.dart';

class FriendScreen extends ConsumerWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRequests = ref.watch(friendRequestsProvider);
    final friends = ref.watch(friendsProvider);
    return Scaffold(
      body: Column(
        children: [
          friendRequests.when(
            data: (requests) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  requests.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          child: const AppText20(
                            'Lời mời kết bạn',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox(),
                  if(requests.isNotEmpty ) ListView.builder(
                    shrinkWrap: true,
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final objFriendShip = requests[index];
                      return ItemListRequest(
                        objFriendShip: objFriendShip,
                        onTapRow: () {
                          Navigator.pushNamed(
                              context, AppRoutesNames.friendProfile,
                              arguments: objFriendShip.senderUsername);
                        },
                        onAccept: () {
                          _acceptFriendRequest(objFriendShip.id, ref);
                        },
                        onReject: () {
                          _rejectFriendRequest(objFriendShip.id, ref);
                        },
                      );
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          SizedBox(height: 20.h),
          friends.when(
            data: (friends) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  friends.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          child: const AppText20('Danh sách bạn bè',
                              fontWeight: FontWeight.bold))
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return ItemListFriend(
                          objFriend: friend,
                          onTapRow: () {
                            Navigator.pushNamed(
                                context, AppRoutesNames.friendProfile,
                                arguments: friend);
                          },
                          onTapAdd: () {
                            ref.read(createChatProvider(friend));
                            Navigator.pushNamed(
                                context, AppRoutesNames.messageScreen,
                                arguments: friend);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (error, stack) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  void _acceptFriendRequest(String friendshipId, WidgetRef ref) {
    ref.read(friendshipProvider.notifier).acceptFriendRequest(friendshipId);
  }

  void _rejectFriendRequest(String friendshipId, WidgetRef ref) {
    ref.read(friendshipProvider.notifier).rejectFriendRequest(friendshipId);
  }
}
