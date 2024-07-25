import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';

class ItemListFriend extends StatelessWidget {
  final Function() onTapRow;
  final Function()? onTapAdd;
  final FriendEntity objFriend;

  const ItemListFriend(
      {super.key,
      required this.objFriend,
      required this.onTapRow,
      this.onTapAdd});

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
                onTapAdd != null
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
                onTapAdd != null
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
                    : const AppIcon(
                        path: ImageRes.icSMS,
                        size: 28,
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
