import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/features/yoga/controller/video_provider.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_widgets.dart';

class YogaScreen extends ConsumerWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.watch(getListVideoFutureProvider);
    return Scaffold(
      appBar: appGlobalAppBar(
        'Thiền và Yoga',
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              VideoEntity objVideo = VideoEntity(
                type: AppConstants.typeVideoYoga,
                title: 'Video Yoga',
                des:
                    'Chào mừng bạn đến với video thiền của tôi nhé, alo bạn ơi, alo bạn à, bạn',
                thumbnail:
                    'https://cdn.hellobacsi.com/wp-content/uploads/2019/07/tam-gi%C3%A1c.png',
              );
              ref
                  .read(getListVideoFutureProvider.notifier)
                  .uploadVideo(objVideo: objVideo);
            },
            icon: const Icon(Icons.upload),
            label: const Text('Upload Video'),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: SingleChildScrollView(
          child: fetchList.when(
              data: (listVideo) {
                final List<VideoEntity> listThien = listVideo
                    .where((video) => video.type == AppConstants.typeVideoThien)
                    .toList();
                final List<VideoEntity> listYoga = listVideo
                    .where((video) => video.type == AppConstants.typeVideoYoga)
                    .toList();
                return Column(
                  children: [
                    const YogaMenu(name: 'Thiền'),
                    SizedBox(height: 10.h),
                    CourseItemGrid(listThien),
                    SizedBox(height: 20.h),
                    const YogaMenu(name: 'Yoga'),
                    SizedBox(height: 10.h),
                    CourseItemGrid(listYoga),
                  ],
                );
              },
              error: (error, stackTrace) => const Center(
                    child: Text('Error'),
                  ),
              loading: () => const Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}
