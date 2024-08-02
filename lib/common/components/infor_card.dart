import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';

class InforNetworkCard extends StatelessWidget {
  final Function()? onTap;
  final String? avatar;
  final String? title;
  final String? subtitle;
  const InforNetworkCard({
    super.key,
    this.onTap,
    required this.avatar,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading:  CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: avatar != null
              ? NetworkImage(avatar!)
              : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
        ),
      title: Text(
        title ?? '',
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class AppListTileDrawer extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final bool isActive;
  final String? path;
  const AppListTileDrawer({
    super.key,
    this.onTap,
    this.isActive = false,
    required this.title,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: const Divider(
            height: 1,
            color: Colors.white12,
          ),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              height: 52.h,
              width: isActive ? 275.w : 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF6792FF),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ListTile(
              onTap: onTap,
              leading: SizedBox(
                height: 25.r,
                width: 25.r,
                child: AppIconAsset(
                  path: path ?? ImageRes.icFoot,
                  iconColor: Colors.white,
                ),
              ),
              title: Text(
                title ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
