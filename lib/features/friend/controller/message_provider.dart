import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/message_entity.dart';
import 'package:nes24_ph55234/data/repositories/message_repos.dart';
import 'package:nes24_ph55234/global.dart';

class MessageNotifier extends FamilyAsyncNotifier<List<MessageEntity>, String> {
  late final String userId;

  @override
  FutureOr<List<MessageEntity>> build(String arg) {
    userId = Global.storageService.getUserId();
    state = const AsyncValue.loading();
    _listenToMessages();
    return [];
  }

  void _listenToMessages() {
    MessageRepos.getMessages(userId, arg).listen(
      (messages) {
        state = AsyncValue.data(messages);
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> sendMessage(String content) async {
    final message = MessageEntity(
      senderId: userId,
      receiverId: arg,
      content: content,
      timestamp: DateTime.now(),
    );
    state.whenData((messages) {
      state = AsyncValue.data([message, ...messages]);
    });
    await MessageRepos.sendMessage(message);
  }

  Future<void> markMessageAsRead(String messageId) async {
    await MessageRepos.markMessageAsRead(messageId);
  }
}

final messageProvider = AsyncNotifierProvider.family<MessageNotifier, List<MessageEntity>, String>(MessageNotifier.new);
