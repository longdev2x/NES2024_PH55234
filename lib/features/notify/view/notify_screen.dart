import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nes24_ph55234/data/models/notify_entity.dart';
import 'package:nes24_ph55234/features/notify/controller/notify_provider.dart';

class NotifyScreen extends ConsumerWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objNotify = ref.watch(notifyProvider);
print('zzz999-${objNotify.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // Implement clear all notifys
            },
          ),
        ],
      ),
      body: objNotify.isEmpty
          ? const Center(child: Text('Không có thông báo'))
          : ListView.separated(
              itemCount: objNotify.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notify = objNotify[index];
                return NotifyTile(objNotify: notify);
              },
            ),
    );
  }
}

class NotifyTile extends ConsumerWidget {
  final NotifyEntity objNotify;

  const NotifyTile({Key? key, required this.objNotify}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: _getnotifyIcon(objNotify.type),
      title: Text(
        objNotify.title,
        style: TextStyle(
          fontWeight: objNotify.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(objNotify.body),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(objNotify.time),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          ref.read(notifyProvider.notifier).removeNotify(objNotify.id);
        },
      ),
      onTap: () {
        if (!objNotify.isRead) {
          ref.read(notifyProvider.notifier).markAsRead(objNotify.id);
        }
        // Handle notify tap
      },
    );
  }

  Widget _getnotifyIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'chat':
        iconData = Icons.chat;
        color = Colors.blue;
        break;
      case 'friend_request':
        iconData = Icons.person_add;
        color = Colors.green;
        break;
      case 'expert_advice':
      case 'user_need_advice':
        iconData = Icons.lightbulb;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(iconData, color: color),
    );
  }
}