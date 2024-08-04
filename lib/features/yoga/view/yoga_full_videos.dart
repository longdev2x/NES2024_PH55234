import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/features/yoga/controller/video_provider.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_widgets.dart';

class YogaFullVideos extends ConsumerWidget {
  const YogaFullVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<VideoEntity> listShowVideo = [];
    final fetchList = ref.watch(getListVideoFutureProvider);
    final String type = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: appGlobalAppBar(type == 'yoga' ? 'Yoga' : 'Thiền định'),
      body: fetchList.when(
          data: (listVideos) {
            if (type == 'yoga') {
              listShowVideo = listVideos
                  .where((video) => video.type == AppConstants.typeVideoYoga)
                  .toList();
            } else {
              listShowVideo = listVideos
                  .where((video) => video.type == AppConstants.typeVideoThien)
                  .toList();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.marginHori),
              child: CourseItemGrid(listShowVideo),
            );
          },
          error: (e, s) => const Center(
                child: Text('Eror'),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
