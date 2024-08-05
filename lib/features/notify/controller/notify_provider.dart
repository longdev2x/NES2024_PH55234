import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/notify_entity.dart';

class NotifyNotifier extends StateNotifier<List<NotifyEntity>> {
  NotifyNotifier() : super([]);

  void addNotify(NotifyEntity notify) {
    print('zzz3333');
    state = [notify,...state];
    print('zzz4444-${state.length}');
  }

  void markAsRead(String id) {
    state = [
      for (final notify in state)
        if (notify.id == id)
          NotifyEntity(
            title: notify.title,
            body: notify.body,
            type: notify.type,
            time: notify.time,
            isRead: true,
          )
        else
          notify,
    ];
  }

  void removeNotify(String id) {
    state = state.where((notify) => notify.id != id).toList();
  }
}

final notifyProvider =
    StateNotifierProvider<NotifyNotifier, List<NotifyEntity>>((ref) {
  return NotifyNotifier();
});
