import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:video_player/video_player.dart';

class YogaDetailScreen extends ConsumerStatefulWidget {
  const YogaDetailScreen({super.key});

  @override
  ConsumerState<YogaDetailScreen> createState() => _YogaDetailScreenState();
}

class _YogaDetailScreenState extends ConsumerState<YogaDetailScreen> {
  late final VideoPlayerController videoPlayerController;
  late final Future<void> _initialize;
  bool isPlay = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    );
    _initialize = videoPlayerController.initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var lessonData = ref.watch(lessonDataVideoProvider);
    return Scaffold(
        appBar: appGlobalAppBar('Yoga Video'),
        body: Center(
          child: Column(
            children: [
              Container(
                width: 325.w,
                height: 200.h,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2019/10/nuoi-meo-can-gi-0-1024x713.jpg')),
                ),
                child: FutureBuilder(
                  future: _initialize,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: 16 / 10,
                        child: VideoPlayer(videoPlayerController),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),

              // Video controls
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //arrow turn back video
                    // GestureDetector(
                    //   onTap: () {
                    //     if (data.index == 0) {
                    //       AppToast.showToast('Không có video cũ hơn');
                    //       return;
                    //     }
                    //     ref
                    //         .read(lessonDataVideoProvider.notifier)
                    //         .playNextVideo(data.lessonItems[data.index - 1].url,
                    //             data.index - 1);
                    //   },
                    //   child: AppImage(
                    //     width: 24.w,
                    //     height: 24.h,
                    //     imagePath: ImageRes.left,
                    //   ),
                    // ),
                    SizedBox(
                      width: 15.h,
                    ),
                    //button play pause video
                    GestureDetector(
                      onTap: () {
                        if (isPlay) {
                          setState(() {
                            videoPlayerController.pause();
                          });
                        } else {
                          setState(() {
                            videoPlayerController.play();
                          });
                        }
                        isPlay = !isPlay;
                      },
                      child: AppIcon(
                        size: 24.r,
                        path: isPlay ? ImageRes.icResume : ImageRes.icPause,
                      ),
                    ),
                    SizedBox(
                      width: 15.h,
                    ),
                    //Arrow turn right video
                    // GestureDetector(
                    //   onTap: () {
                    //     if (data.index == data.lessonItems.length) {
                    //       toastInfo('No More Videos');
                    //       return;
                    //     }
                    //     ref
                    //         .read(lessonDataVideoProvider.notifier)
                    //         .playNextVideo(data.lessonItems[data.index + 1].url,
                    //             data.index + 1);
                    //   },
                    //   child: AppImage(
                    //     width: 24.w,
                    //     height: 24.h,
                    //     imagePath: ImageRes.right,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              //video list
            ],
          ),
        ));
  }
}
