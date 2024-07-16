import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/main.dart';

class AppIcon extends StatelessWidget {
  final String path;
  final double? size;
  final Color? iconColor;
  const AppIcon({
    super.key,
    required this.path,
    this.size = 22,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size!.w,
      child: Image.asset(
        path,
        color: isDarkGlobal ? Colors.white : Colors.black,
      ),
    );
  }
}


class AppIconWithBgColor extends StatelessWidget {
  const AppIconWithBgColor(
      {super.key,
      this.imagePath = ImageRes.avatarDefault,
      this.width = 16,
      this.height = 16,
      this.color = AppColors.primaryElement});
  final String imagePath;
  final double width;
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width.w,
      height: height.h,
      color: color,
    );
  }
}