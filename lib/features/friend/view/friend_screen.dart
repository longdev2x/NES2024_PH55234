import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_search_bar.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_provider.dart';

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  @override
  ConsumerState createState() => _FriendScreenState();
}

class _FriendScreenState extends ConsumerState<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    final friendRequests = ref.watch(friendRequestsProvider);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170.h),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AppSearchBar(
              onTap: () {
                Navigator.pushNamed(context, AppRoutesNames.friendSearch);
              },
              hintText: 'Tìm bạn bè',
              readOnly: true,
            ),
          ),
        ),
        body: friendRequests.when(
          data: (requests) => ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text('Friend Request from ${request.userId}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      child: const Text('Accept'),
                      onPressed: () => _acceptFriendRequest(request.id),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _rejectFriendRequest(request.id),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  void _acceptFriendRequest(String friendshipId) {
    ref.read(friendshipProvider.notifier).acceptFriendRequest(friendshipId);
  }

  void _rejectFriendRequest(String friendshipId) {
    ref.read(friendshipProvider.notifier).rejectFriendRequest(friendshipId);
  }
}
