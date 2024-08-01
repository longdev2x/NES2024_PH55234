import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/advise_entity.dart';
import 'package:nes24_ph55234/data/repositories/advise_repos.dart';
import 'package:nes24_ph55234/features/advise/controller/advise_provider.dart';
import 'package:nes24_ph55234/global.dart';

class AdviseChatDetailScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String content;
  const AdviseChatDetailScreen({
    super.key,
    required this.sessionId,
    required this.content,
  });

  @override
  ConsumerState createState() => _AdviseChatDetailScreenState();
}

class _AdviseChatDetailScreenState
    extends ConsumerState<AdviseChatDetailScreen> {
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
    final sessionStream =
        ref.watch(adviseSessionDetailProvider(widget.sessionId));

    return Scaffold(
      appBar: appGlobalAppBar('Tư vấn tâm lý'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.marginHori,
            vertical: AppConstants.marginVeti),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppText24('Nội dung cần tư vấn:'),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AppConfirm(
                        title: widget.content,
                        onConfirm: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  child: const AppText16('Xem đầy đủ'),
                ),
              ],
            ),
            Text(
              widget.content,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),
            const Divider(),
            Expanded(
              child: sessionStream.when(
                data: (session) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: session.messages.length,
                    itemBuilder: (context, index) {
                      final message = session.messages[index];
                      return MessageBubble(
                        message: message.message,
                        isMe: message.senderId ==
                            Global.storageService.getUserId(),
                        isExpert: message.isExpert,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      decoration: const InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = AdviseMessage(
      message: _messageController.text,
      senderId: Global.storageService.getUserId(),
      timestamp: DateTime.now(),
      isExpert: Global.storageService.getRole() == AppConstants.roleExpert,
    );

    await AdviseRepos.addMessageToSession(widget.sessionId, message);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isExpert;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.isExpert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundColor: isExpert ? Colors.blue : Colors.grey,
              child: AppImage(imagePath: isExpert ? ImageRes.icExpert : ImageRes.icUser, height: 35.r, width: 35.r,),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.blue[800] : Colors.black87,
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: AppImage(imagePath: !isExpert ? ImageRes.icExpert : ImageRes.icUser, height: 35.r, width: 35.r,),
            ),
          ],
        ],
      ),
    );
  }
}
