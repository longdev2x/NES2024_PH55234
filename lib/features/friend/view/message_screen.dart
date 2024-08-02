import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/models/message_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/message_provider.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FriendEntity objFriend =
        ModalRoute.of(context)!.settings.arguments as FriendEntity;
    final fetchMessage = ref.watch(messageProvider(objFriend.friendId));

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: objFriend.avatar != null
                ? NetworkImage(objFriend.avatar!)
                : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
            radius: 20,
          ),
          title: AppText16(objFriend.username),
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: fetchMessage.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                      child: AppText20('Chưa ghi nhận lịch sử nhắn tin'));
                }
                return _buildMessageList(messages, objFriend.avatar);
              },
              error: (error, _) {
                return Center(child: Text('Error: $error'));
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          _buildMessageInput(objFriend),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<MessageEntity> messages, String? avatar) {
    final currentUserId =
        ref.read(messageProvider(messages.first.receiverId).notifier).userId;
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == currentUserId;
        return MessageBubble(
          message: message,
          isMe: isMe,
          avatar: avatar,
          isFirstMess: index == 0 || messages[index].senderId != messages[index -1].senderId,
        );
      },
    );
  }

  Widget _buildMessageInput(FriendEntity friend) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Bạn muốn nhắn gì...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  ref
                      .read(messageProvider(friend.friendId).notifier)
                      .sendMessage(_messageController.text);
                  _messageController.clear();
                  _scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final String? avatar;
  final bool isMe;
  final bool isFirstMess;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.isFirstMess,
      required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isFirstMess && !isMe
                ? CircleAvatar(
                    backgroundImage: avatar != null
                        ? NetworkImage(avatar!)
                        : const AssetImage(ImageRes.avatarDefault)
                            as ImageProvider,
                  )
                : const SizedBox(),
            SizedBox(width: 8.w),
            Container(
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: isMe ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
