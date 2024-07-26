import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/message_entity.dart';

class ItemListChat extends StatelessWidget {
  final Function() onTapRow;
  final ChatEntity objChat;

  const ItemListChat({
    super.key,
    required this.objChat,
    required this.onTapRow,
  });

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
                  backgroundImage: objChat.partnerAvatar != null
                      ? NetworkImage(objChat.partnerAvatar!)
                      : const AssetImage(ImageRes.avatarDefault)
                          as ImageProvider,
                  radius: 25,
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText16(
                      objChat.partnerUsername,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText14(objChat.lastMsg),
                  ],
                ),
                const Spacer(),
                AppText14(getTimeAgo(objChat.time)),
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
