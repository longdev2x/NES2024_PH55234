import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_box_decoration.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';

class AppSearchBar extends StatelessWidget {
  final Function()? onTap;
  final Function(String value)? onChanged;
  const AppSearchBar({super.key, this.onTap, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: 17.h),
          width: 280.w,
          height: 40.h,
          decoration: appBoxShadow(
              color: AppColors.primaryBackground,
              boxBorder: Border.all(color: AppColors.primaryElement)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppImage(imagePath: ImageRes.search),
              Container(
                width: 240.w,
                height: 40.h,
                alignment: Alignment.center,
                child: const AppTextFieldNoborder(
                    width: 240, 
                    height: 40, 
                    action: TextInputAction.search,
                    hintText: 'Search your course...'),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(5.w),
            width: 40.w,
            height: 40.h,
            decoration: appBoxShadow(
              boxBorder: Border.all(color: AppColors.primaryElement),
            ),
            child: const AppImage(imagePath: ImageRes.search, color: Colors.white,),
          ),
        ),
      ],
    );
  }
}

