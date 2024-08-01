import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_box_decoration.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/features/yoga/controller/video_provider.dart';
import 'package:video_player/video_player.dart';

class AnotherVideoWidget extends ConsumerWidget {
  final String? type;
  final ScrollController scrollController;
  const AnotherVideoWidget(
      {super.key, required this.scrollController, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.read(getListVideoFutureProvider);
    final VideoEntity videoChose = ref.watch(videoControlProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText14("Video khác", fontWeight: FontWeight.bold),
        SizedBox(height: 20.h),
        fetchList.when(
            data: (data) {
              final listVideo = data.where((e) => e.type == type).toList();
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listVideo.length,
                  itemBuilder: (ctx, index) {
                    Color bgColorChosed = videoChose.id == listVideo[index].id
                        ? AppColors.primaryElement
                        : AppColors.primaryBackground;
                    return InkWell(
                      onTap: () {
                        ref.read(videoControlProvider.notifier).state =
                            listVideo[index];
                        scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 325.w,
                        height: 100.h,
                        padding: EdgeInsets.all(10.w),
                        decoration: appBoxShadow(color: bgColorChosed),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            listVideo[index].url != null
                                ? AppCachedNetworkImage(
                                    imagePath: listVideo[index].thumbnail!,
                                    boxFit: BoxFit.fitWidth,
                                    height: 60,
                                    width: 100,
                                  )
                                : Image.asset(ImageRes.imgDefaultThien),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText16(listVideo[index].title ?? "No name",
                                      maxLines: 1,
                                      color: AppColors.primaryText),
                                  AppText14(
                                    listVideo[index].title ?? "No name",
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            const Spacer(),
                            const AppIconAsset(
                                path: ImageRes.icArrowRight, size: 24),
                          ],
                        ),
                      ),
                    );
                  });
            },
            error: (error, stackTrace) => const Center(
                  child: Text('Error get list'),
                ),
            loading: () => const Center(child: CircularProgressIndicator())),
      ],
    );
  }
}

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  //Lúc change video, không khởi tạo lại nên không được để final _objVideo
  late VideoEntity _objVideo;
  late FlickManager _flickManager;

  @override
  void initState() {
    super.initState();
    _objVideo = ref.read(videoControlProvider);
    if (_objVideo.url != null) {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(_objVideo.url!),
        ),
      );
    }
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _objVideo = ref.watch(videoControlProvider);
    if (_objVideo.url != null) {
      _flickManager.handleChangeVideo(
          VideoPlayerController.networkUrl(Uri.parse(_objVideo.url!)));
    }
    return Container(
      width: 375.w,
      height: 230.h,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: _objVideo.thumbnail != null
                ? NetworkImage(_objVideo.thumbnail!)
                : const AssetImage(ImageRes.imgDefaultYoga) as ImageProvider),
      ),
      child: _objVideo.url == null
          ? _nullVideo()
          : AspectRatio(
              aspectRatio: 16 / 10,
              child: FlickVideoPlayer(flickManager: _flickManager),
            ),
    );
  }

  Widget _nullVideo() => SizedBox(
      width: 325.w,
      height: 200.h,
      child: const Center(child: Text('Không có video')));
}
