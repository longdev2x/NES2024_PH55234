import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
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
                onTapAdd != null
                  ? ElevatedButton.icon(onPressed: onTapAdd, icon: AppIcon(path: ImageRes.icAddFriend, size: 12.r,),label: const Text('Kết bạn', style: TextStyle(fontWeight: FontWeight.bold),))
                  : const AppIcon(path: ImageRes.icSMS)
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
