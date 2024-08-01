import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/main.dart';

AppBar appGlobalAppBar(String? title, {List<Widget>? actions}) {
  BuildContext context = navKey.currentContext!;
  return AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: title == null
        ? null
        : Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
    centerTitle: true,
    actions: actions,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1.h),
      child: Container(
        color: Theme.of(context).dividerColor.withOpacity(0.3),
        height: 1.h,
      ),
    ),
  );
}
