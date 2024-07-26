import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';
import 'package:nes24_ph55234/features/friend/controller/friend_post_provider.dart';
import 'package:nes24_ph55234/global.dart';

class ItemListFriend extends StatelessWidget {
  final Function() onTapRow;
  final Function() onTapAdd;
  final bool isAddFriend;
  final FriendEntity objFriend;

  const ItemListFriend(
      {super.key,
      required this.objFriend,
      required this.onTapRow,
      this.isAddFriend = false,
      required this.onTapAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapRow,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: objFriend.avatar != null
                      ? NetworkImage(objFriend.avatar!)
                      : const AssetImage(ImageRes.avatarDefault)
                          as ImageProvider,
                  radius: 25,
                ),
                SizedBox(width: 12.w),
                isAddFriend
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText16(
                              objFriend.username,
                              fontWeight: FontWeight.bold,
                            ),
                            AppText14(
                              'Vai trò: ${objFriend.role?.name ?? 'Nguời dùng'}',
                            ),
                          ],
                        ),
                      )
                    : AppText20(objFriend.username),
                const Spacer(),
                isAddFriend
                    ? ElevatedButton.icon(
                        onPressed: onTapAdd,
                        icon: AppIcon(
                          path: ImageRes.icAddFriend,
                          size: 12.r,
                        ),
                        label: const Text(
                          'Kết bạn',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                    : GestureDetector(
                      onTap: onTapAdd,
                      child: const AppIcon(
                          path: ImageRes.icSMS,
                          size: 28,
                        ),
                    )
              ],
            ),
          ),
          // Divider
          Row(
            children: [
              const SizedBox(width: 62),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemListRequest extends StatelessWidget {
  final Function() onTapRow;
  final Function()? onAccept;
  final Function()? onReject;
  final FriendshipEntity objFriendShip;

  const ItemListRequest(
      {super.key,
      required this.objFriendShip,
      required this.onTapRow,
      this.onAccept,
      this.onReject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapRow,
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: AppConstants.marginHori, vertical: 6.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: objFriendShip.senderAvatar != null
                        ? NetworkImage(objFriendShip.senderAvatar!)
                        : const AssetImage(ImageRes.avatarDefault)
                            as ImageProvider,
                    radius: 25,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText16(
                          objFriendShip.senderUsername,
                          fontWeight: FontWeight.bold,
                        ),
                        AppText14(
                          'Vai trò: ${objFriendShip.role.name}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onAccept,
                    child: const Text(
                      'Đồng ý',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onAccept,
                    child: const Text(
                      'Từ chối',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FPostHeaderWidget extends ConsumerWidget {
  final String? avatar;
  final Function() onTapRow;
  final Function() onTapImagePicker;
  const FPostHeaderWidget({
    super.key,
    required this.avatar,
    required this.onTapImagePicker,
    required this.onTapRow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTapRow,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.marginHori,
            vertical: AppConstants.marginVeti),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: avatar != null
                  ? NetworkImage(avatar!)
                  : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
              radius: 25,
            ),
            SizedBox(width: 12.w),
            const AppText16('bạn đang nghĩ gì'),
            const Spacer(),
            GestureDetector(
              onTap: onTapImagePicker,
              child: const AppImage(
                imagePath: ImageRes.icImagePicker,
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendDiverWidget extends StatelessWidget {
  const FriendDiverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 4.h,
      color: const Color.fromRGBO(211, 185, 193, 1),
    );
  }
}

class FpostContent extends ConsumerWidget {
  const FpostContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchPosts = ref.watch(friendPostProvider);
    return fetchPosts.when(
        data: (posts) {
          return _buildContent(ref, posts);
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error-$error'));
        },
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Widget _buildContent(WidgetRef ref, List<PostFriendEntity> posts) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return PostFriendItem(objPostFriend: posts[index]);
        },
        separatorBuilder: (context, index) => const FriendDiverWidget(),
        itemCount: posts.length);
  }
}

class PostFriendItem extends ConsumerWidget {
  final PostFriendEntity objPostFriend;
  const PostFriendItem({super.key, required this.objPostFriend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String currentUserId = Global.storageService.getUserId();
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.marginHori,
          vertical: AppConstants.marginVeti),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: objPostFriend.avatar != null
                    ? NetworkImage(objPostFriend.avatar!)
                    : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
                radius: 25,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText16(
                    objPostFriend.username,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText14(objPostFriend.formatDate),
                ],
              ),
              const Spacer(),
              AppImage(
                imagePath: emoijMap[objPostFriend.feel],
                width: 40.w,
                height: 40.h,
                boxFit: BoxFit.fitHeight,
              )
            ],
          ),
          SizedBox(height: 10.h),
          AppText20(
            objPostFriend.content,
            maxLines: null,
          ),
          SizedBox(height: 10.h),
          // Hiển thị tối đa 2 dong text đầu tiên
          // Hiển thị hàng ảnh
          Wrap(
            spacing: 8, // Khoảng cách giữa các ảnh theo chiều ngang
            runSpacing:
                8, // Khoảng cách giữa các hàng (nếu có nhiều hơn một hàng)
            children: List.generate(
              min(3, objPostFriend.images.length),
              (index) {
                if (objPostFriend.images[index] == null) {
                  return const SizedBox();
                }
                return index == 2 && objPostFriend.images.length > 3
                    ? Stack(
                        children: [
                          Image.network(
                            objPostFriend.images[index]!,
                            fit: BoxFit.cover,
                            height: 75.h,
                            width: 107.w,
                          ),
                          Positioned.fill(
                            child: Container(
                              height: 75.h,
                              width: 107.w,
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                child: AppText20(
                                  '+${objPostFriend.images.length - 3}',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Image.network(
                        objPostFriend.images[index]!,
                        fit: BoxFit.cover,
                        height: 75.h,
                        width: 107.w,
                      );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(friendPostProvider.notifier).toggleLike(objPostFriend.id);
                },
                child: AppImage(
                  imagePath: objPostFriend.likes.contains(currentUserId)
                      ? ImageRes.icLove
                      : ImageRes.icDislike,
                  height: 25.r,
                  width: 25.r,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
