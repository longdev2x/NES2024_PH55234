import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? name;
  final double? radius;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final Function()? ontap;

  const AppButton({
    super.key,
    this.ontap,
    this.radius = 26,
    this.height = 45,
    this.width = double.infinity,
    this.name = "",
    this.bgColor = AppColors.bgButton,
    this.textColor = Colors.white,
    this.fontSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        alignment: Alignment.center,
        height: height!.h,
        width: width!.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor!,
              bgColor!.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(radius!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          name!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: fontSize!.sp,
          ),
        ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  const AppOutlineButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        elevation: 5,
        side: BorderSide(color: Colors.indigo[400]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
      child: AppText16(
        text,
        color: Colors.indigo[700],
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

//Cần set Width khi đặt trong 1 row
class AppButtonWithIcon extends StatelessWidget {
  final String iconPath;
  final double? height;
  final double? width;
  final String? name;
  final double? radius;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final Function()? ontap;

  const AppButtonWithIcon(
      {super.key,
      required this.iconPath,
      this.ontap,
      this.radius = 26,
      this.height = 45,
      this.width = double.infinity,
      this.name = "",
      this.bgColor = AppColors.bgButton,
      this.textColor = Colors.white,
      this.fontSize = 19});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: height!.h,
        width: width!.w,
        decoration: BoxDecoration(
          color: bgColor!,
          borderRadius: BorderRadius.circular(radius!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 12.w),
            AppIconAsset(
              path: iconPath,
              iconColor: Colors.white,
            ),
            const Spacer(),
            Text(
              name!,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize!.sp,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class AppElevatedButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? width;
  final double? height;
  final double? radius;
  final double? fontSize;
  final Color? bgColor;
  final Color? textColor;
  final FontWeight fontWeight;
  final Color? borderColor;
  const AppElevatedButton(
      {super.key,
      required this.text,
      this.onTap,
      this.width = 325,
      this.height = 60,
      this.fontSize = 25,
      this.fontWeight = FontWeight.bold,
      this.bgColor = AppColors.bgButton,
      this.textColor = AppColors.primaryElementText,
      this.borderColor = Colors.transparent,
      this.radius = 35});
  @override
  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width!.w,
        height: height!.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // gradient: LinearGradient(colors: [color!.withOpacity(0.85), color!]),
            color: bgColor,
            borderRadius: BorderRadius.circular(radius!),
            border: Border.all(color: borderColor!)),
        child: Text(text,
            style: TextStyle(
                fontWeight: fontWeight,
                color: textColor,
                fontSize: fontSize!.sp)),
      ),
    );
  }
}
