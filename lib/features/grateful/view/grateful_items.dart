import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/features/grateful/controller/post_grateful_provider.dart';
import 'package:nes24_ph55234/features/grateful/view/post_bottom_screen.dart';

class GratefulPostItem extends ConsumerWidget {
  final PostGratefulEntity objPost;
  const GratefulPostItem({super.key, required this.objPost});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Content item loại text
    final textItems = objPost.contentItems
        .where((item) =>
            item.type == 'text' &&
            item.content != null &&
            item.content!.isNotEmpty)
        .toList();

    // Content item loại image
    final imageItems = objPost.contentItems
        .where((item) => item.type == 'image' && item.content != null)
        .toList();

    return GestureDetector(
      onTap: () {
        ref.read(createPostGratefulProvider.notifier).initEdit(objPost);
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => const PostBottomScreen());
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.marginHori,
              vertical: AppConstants.marginVeti),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText20(
                    objPost.formatDate,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  AppImage(
                    imagePath: emoijMap[objPost.feel],
                    width: 40.w,
                    height: 40.h,
                    boxFit: BoxFit.fitHeight,
                  )
                ],
              ),
              SizedBox(height: 5.h),
              if (objPost.title != null)
                Align(
                    alignment: Alignment.topCenter,
                    child: AppText26(objPost.title!)),
              // Hiển thị tối đa 2 text đầu tiên
              ...textItems.take(2).map((item) => AppText20(item.content!)),
              if (textItems.length > 2) const Text('...'),
              SizedBox(height: 10.h),
              // Hiển thị hàng ảnh
              Wrap(
                spacing: 5,
                runSpacing: 8,
                children: List.generate(
                  min(3, imageItems.length),
                  (index) {
                    return index == 2 && imageItems.length > 3
                        ? Stack(
                            children: [
                              Image.network(
                                imageItems[index].content!,
                                fit: BoxFit.cover,
                                height: 70.h,
                                width: 96.w,
                              ),
                              Positioned.fill(
                                child: Container(
                                  height: 70.h,
                                  width: 96.w,
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: AppText20(
                                      '+${imageItems.length - 3}',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Image.network(
                            imageItems[index].content!,
                            fit: BoxFit.cover,
                            height: 70.h,
                            width: 96.w,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
