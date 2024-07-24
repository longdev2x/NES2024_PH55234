import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/repositories/friend_repos.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_provider.dart';
import 'package:nes24_ph55234/global.dart';

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  @override
  ConsumerState createState() => _FriendScreenState();
}

class _FriendScreenState extends ConsumerState<FriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FriendEntity> _searchResults = [];

  @override
  Widget build(BuildContext context) {
      print('zzzz11${Global.storageService.getUserId()}');

    final friendRequests = ref.watch(friendRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search friends',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return ListTile(
                  title: Text(user.name),
                  trailing: ElevatedButton(
                    child: const Text('Add Friend'),
                    onPressed: () => _sendFriendRequest(user.id),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: friendRequests.when(
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
        ],
      ),
    );
  }

  void _performSearch() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final results = await FriendRepos.searchUsers(query);
      setState(() {
        _searchResults = results;
      });
    }
  }

  void _sendFriendRequest(String friendId) {
    ref.read(friendshipProvider.notifier).sendFriendRequest(friendId);
  }

  void _acceptFriendRequest(String friendshipId) {
    ref.read(friendshipProvider.notifier).acceptFriendRequest(friendshipId);
  }

  void _rejectFriendRequest(String friendshipId) {
    ref.read(friendshipProvider.notifier).rejectFriendRequest(friendshipId);
  }
}