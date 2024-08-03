import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
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
        elevation: 2,
        margin: EdgeInsets.only(bottom: 14.h),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      objPost.formatDate,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AppImage(
                    imagePath: emoijMap[objPost.feel],
                    width: 32.w,
                    height: 32.h,
                    boxFit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              if (objPost.title != null) ...[
                SizedBox(height: 12.h),
                Text(
                  objPost.title!,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 8.h),
              // Hiển thị tối đa 2 text đầu tiên
              ...textItems.take(2).map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      item.content!,
                      style: TextStyle(fontSize: 14.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              if (textItems.length > 2)
                Text('...', style: TextStyle(fontSize: 14.sp)),
              if (imageItems.isNotEmpty) ...[
                SizedBox(height: 12.h),
                // Hiển thị hàng ảnh
                SizedBox(
                  height: 80.h,
                  child: Row(
                    children: [
                      ...List.generate(
                        min(3, imageItems.length),
                        (index) {
                          if (index == 2 && imageItems.length > 3) {
                            return Stack(
                              children: [
                                _buildImageThumbnail(
                                    imageItems[index].content!),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+${imageItems.length - 3}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return _buildImageThumbnail(
                              imageItems[index].content!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String imageUrl) {
    return Container(
      width: 80.w,
      height: 80.h,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
