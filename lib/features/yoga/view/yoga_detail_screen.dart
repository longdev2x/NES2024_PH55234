import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_detail_widget.dart';

class YogaDetailScreen extends ConsumerStatefulWidget {
  const YogaDetailScreen({super.key});

  @override
  ConsumerState<YogaDetailScreen> createState() => _YogaDetailScreenState();
}

class _YogaDetailScreenState extends ConsumerState<YogaDetailScreen> {
  late final ScrollController _scrollController;
  late VideoEntity objVideo;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    objVideo = ModalRoute.of(context)?.settings.arguments as VideoEntity;
    return Scaffold(
        appBar: appGlobalAppBar(objVideo.title),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                const VideoPlayerWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.marginHori,
                      vertical: AppConstants.marginVeti),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(objVideo.des ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis), maxLines: 4,),
                      GestureDetector(onTap: () {}, child: const AppText14('Xem thêm', color: Colors.blue,)),
                      SizedBox(height: 10.h),
                      AnotherVideoWidget(scrollController: _scrollController, type: objVideo.type,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
