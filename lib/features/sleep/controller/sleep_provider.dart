import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/sleep_entity.dart';
import 'package:nes24_ph55234/data/repositories/sleep_repos.dart';
import 'package:nes24_ph55234/global.dart';

final isTrackingProvider = StateProvider<bool>(
  (ref) => false,
);
//Để rebuild lại giao diện ( Timer sẽ gọi provider này)
final currentTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

final sleepProvider = StateNotifierProvider<SleepNotifier, List<SleepEntity>>((ref) => SleepNotifier(),);

//Main
class SleepNotifier extends StateNotifier<List<SleepEntity>> {
  SleepNotifier() : super([]) {
    _fetchSleepEntries();
  }

  void _fetchSleepEntries() {
    SleepRepos.getSleepEntries(Global.storageService.getUserId())
        .listen((sleepEntries) {
      state = sleepEntries;
    });
  }

  Future<void> startSleep({required DateTime startTime}) async {
    final sleep = SleepEntity(
      userId: Global.storageService.getUserId(),
      startTime: startTime,
    );
    await SleepRepos.addSleep(sleep);
  }

  Future<void> stopSleep({required DateTime endTime}) async {
    final updatedSleep = state.first.copyWith(endTime: endTime);
    await SleepRepos.updateSleep(updatedSleep);
  }
}