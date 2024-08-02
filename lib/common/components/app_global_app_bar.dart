import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/main.dart';

AppBar appGlobalAppBar(String? title, {List<Widget>? actions}) {
  BuildContext context = navKey.currentContext!;
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: title == null
        ? null
        : Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
    centerTitle: true,
    actions: actions,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(10.r),
      ),
    ),
  );
}