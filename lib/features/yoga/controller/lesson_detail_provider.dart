

// VideoPlayerController? videoPlayerController;
// @riverpod
// Future<void> lessonDetail(LessonDetailRef ref, {required int id}) async {
//   LessonRequestEntity lessonRequestEntity = LessonRequestEntity(id: id);
//   final lessonDetailResponse =
//       await LessonDetailRepo.lessonDetail(lessonRequestEntity);
//   if (lessonDetailResponse == null) {
//     return;
//   }
//   if (lessonDetailResponse.code == 200) {
//     String url =
//         '${AppConstants.imageUploadsPath}${lessonDetailResponse.data!.elementAt(0).url}';
//     // String url = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
//     videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
//     var initializeVideoPlayer =
//         videoPlayerController?.initialize().then((value) {
//       //seekTo run video from ...
//       videoPlayerController?.seekTo(const Duration(seconds: 0));
//       videoPlayerController?.play();
//     });

//     LessonVideo lessonVideo = LessonVideo(
//         lessonItems: lessonDetailResponse.data!,
//         initializeVideoPlayer: initializeVideoPlayer,
//         isPlay: true);

//     ref
//         .read(lessonDataVideoProvider.notifier)
//         .updateLessonDataVideo(lessonVideo);
//   } else {
//     if (kDebugMode) {
//       print('Error ---- ${lessonDetailResponse.code}');
//     }
//   }
// }

// @riverpod
// class LessonDataVideo extends _$LessonDataVideo {
//   @override
//   FutureOr<LessonVideo> build() async {
//     return const LessonVideo();
//   }

//   void updateLessonDataVideo(LessonVideo lessonVideo) {
//     update((data) => data.copyWith(
//         lessonItems: lessonVideo.lessonItems,
//         initializeVideoPlayer: lessonVideo.initializeVideoPlayer,
//         isPlay: lessonVideo.isPlay));
//   }

//   void playPause(bool isPlay) {
//     update((data) => data.copyWith(
//           isPlay: isPlay,
//         ));
//   }

//   void playNextVideo(String? url, int index) {
//     if (videoPlayerController != null) {
//       videoPlayerController!.pause();
//       videoPlayerController!.dispose();
//     }
//     String videoUrl = '${AppConstants.imageUploadsPath}$url';
//     videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//     Future<void>? initializeVideoPlayer = videoPlayerController?.initialize();
//     videoPlayerController?.play();
//     update((data) => data.copyWith(
//         initializeVideoPlayer: initializeVideoPlayer,
//         isPlay: true,
//         index: index));
//   }

// }
