import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/models/message_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/chat_provider.dart';
import 'package:nes24_ph55234/features/friend/view/chat_widgets.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchChats = ref.watch(chatProvider);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
      child: fetchChats.when(
          data: (chats) {
            return _buildContent(ref, chats);
          },
          error: (error, stackTrace) {
            return Center(
              child: Text('Error $error'),
            );
          },
          loading: () => const CircularProgressIndicator()),
    ));
  }

  Widget _buildContent(WidgetRef ref, List<ChatEntity> chats) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        ChatEntity objChat = chats[index];
        return ItemListChat(
          objChat: objChat,
          onTapRow: () {
            Navigator.pushNamed(context, AppRoutesNames.messageScreen,
                arguments: FriendEntity(friendId: objChat.partnerId, username: objChat.partnerUsername, avatar: objChat.partnerAvatar));
          },
        );
      },
    );
  }
}
