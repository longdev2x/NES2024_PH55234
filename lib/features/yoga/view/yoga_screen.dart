import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_widgets.dart';

class YogaScreen extends StatelessWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appGlobalAppBar('Thiền và Yoga'),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const YogaMenu(name: 'Thiền'),
              SizedBox(height: 10.h),
              const CourseItemGrid(),
              const YogaMenu(name: 'Yoga'),
              SizedBox(height: 10.h),
              const CourseItemGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
