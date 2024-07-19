import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/data/repositories/video_repos.dart';

class ListVideoNotifer extends AutoDisposeAsyncNotifier<List<VideoEntity>> {
  @override
  FutureOr<List<VideoEntity>> build() {
    return _fetchList();
  }

  Future<List<VideoEntity>> _fetchList() async {
    return await VideoRepos.getAllVideo();
  }

  Future<void> uploadVideo({required VideoEntity objVideo}) async {
    await VideoRepos.uploadVideo(objVideo);
    state = await AsyncValue.guard(() async => await _fetchList());
  }
}

final getListVideoFutureProvider =
    AutoDisposeAsyncNotifierProvider<ListVideoNotifer, List<VideoEntity>>(
  () => ListVideoNotifer(),
);

final videoControlProvider = StateProvider<VideoEntity>((ref) => VideoEntity(type: AppConstants.typeVideoYoga));

// VideoPlayerController? videoPlayerController;

// class VideoControlNotifier
//     extends AutoDisposeFamilyAsyncNotifier<VideoControlEntity, String> {
//   @override
//   FutureOr<VideoControlEntity> build(arg) {
//     return _initVideo(arg);
//   }

//   Future<VideoControlEntity> _initVideo(String url) async {
//     videoPlayerController = VideoPlayerController.networkUrl(
//       Uri.parse(url),
//     );
//     if (videoPlayerController == null) {
//       if (kDebugMode) {
//         print('Link video sai');
//       }
//     }
//     await videoPlayerController!.initialize();
//     videoPlayerController!.play();
//     return VideoControlEntity(url: url, isPlayed: true);
//   }

//   Future<void> pausePlay({required bool isPlayed}) async {
//     if(isPlayed) {
//       await videoPlayerController?.pause();
//     } else {
//       await videoPlayerController?.play();
//     }
//     state = state.whenData((value) => value.copyWith(isPlayed: isPlayed));
//   }

//   Future<void> seekTo(int second) async {
//     await videoPlayerController?.seekTo(Duration(seconds: second));
//   }

//   Future<void> volume(double volume) async {
//     await videoPlayerController?.setVolume(volume);
//     state = state.whenData((value) => value.copyWith(volume: volume));
//   }
// }

// final videoControlProvider = AutoDisposeAsyncNotifierProviderFamily<VideoControlNotifier,
//     VideoControlEntity, String?>(() => VideoControlNotifier());
