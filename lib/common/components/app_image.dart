import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';

class AppImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final Function()? onTap;
  final BoxFit? boxFit;
  final Color? color;

  const AppImage(
      {super.key,
      this.imagePath = ImageRes.avatarDefault,
      this.width = 16,
      this.height = 16,
      this.onTap,
      this.color,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        width: width.w,
        height: height.h,
        fit: boxFit,
        color: color,
      ),
    );
  }
}

class AppImageWithColor extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final String? subTitle;
  final String? imagePath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit boxFit;
  const AppImageWithColor(
      {super.key,
      this.onTap,
      this.title,
      this.subTitle,
      this.imagePath = ImageRes.avatarDefault,
      this.width = 16,
      this.height = 16,
      this.boxFit = BoxFit.fitWidth,
      this.color});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width!.w,
        height: height!.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.w),
          image: DecorationImage(
              fit: boxFit,
              image: AssetImage(imagePath ?? ImageRes.avatarDefault)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, bottom: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeText(text: title ?? ''),
              FadeText(
                  text: subTitle ?? '',
                  color: AppColors.primaryFourElementText,
                  fontSize: 8.sp),
            ],
          ),
        ),
      ),
    );
  }
}


class AppCachedNetworkImage extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  final BoxFit boxFit;
  final String? title;
  final String? subTitle;
  final void Function()? onTap;

  const AppCachedNetworkImage(
      {super.key,
      this.width = 40,
      this.height = 40,
      this.boxFit = BoxFit.fitWidth,
      this.onTap,
      this.title,
      this.subTitle,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imagePath,
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height.h,
            width: width.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              image: DecorationImage(fit: boxFit, image: imageProvider),
            ),
            child: Padding(
                    padding: EdgeInsets.only(left: 14.w, bottom: 60.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeText(text: title ?? '',fontSize: 12,),
                        FadeText(
                            text: subTitle ?? '',
                            color: AppColors.primaryFourElementText,
                            fontSize: 8.sp),
                      ],
                    ),
                  ),
          );
        },
        placeholder: (context, url) => SizedBox(
        height: 20.h,
        width: 20.h,
        child: const Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Image.asset(ImageRes.imgError),
      ),
    );
  }
}