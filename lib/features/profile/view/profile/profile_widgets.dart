
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';

class ProfileRowInforWidgets extends StatelessWidget {
  final UserEntity objUser;
  const ProfileRowInforWidgets({super.key, required this.objUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText14('${objUser.age ?? '...'} (tuổi) | ', fontWeight: FontWeight.bold,),
          AppText14('${objUser.height ?? '...'} (cm) | ', fontWeight: FontWeight.bold,),
          AppText14('${objUser.weight ?? '...'} (kg) | ', fontWeight: FontWeight.bold,),
          AppText14('${objUser.bmi ?? '...'} (kg/m2)', fontWeight: FontWeight.bold,),
      ],),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String icon;
  final String text;
  final bool isRight;
  final Function()? onTap;
  const ProfileListItem({
    super.key,
    required this.text,
    required this.icon,
    this.isRight = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Theme.of(context).focusColor
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          AppIcon(path: icon, size: 18,),
          SizedBox(width: 20.w),
          AppText16(text, fontWeight: FontWeight.w600,),
          const Spacer(),
          if(isRight) 
            const AppIcon(path: ImageRes.icArrowRight, size: 14,),
        ],),
      ),
    );
  }
}
