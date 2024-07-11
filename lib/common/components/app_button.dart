import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? name;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final Function()? ontap;

  const AppButton({
    super.key,
    this.ontap,
    this.height = 45,
    this.width = double.infinity,
    this.name = "",
    this.bgColor = AppColors.bgButton,
    this.textColor = Colors.white,
    this.fontSize = 19
  });

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
          borderRadius: BorderRadius.circular(26)
        ),
        child: Text(
          name!,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize!.sp
          ),
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
          border: Border.all(color: borderColor!)
        ),
        child: Text(text,
            style: TextStyle(
                fontWeight: fontWeight,
                color: textColor,
                fontSize: fontSize!.sp)),
      ),
    );
  }
}
