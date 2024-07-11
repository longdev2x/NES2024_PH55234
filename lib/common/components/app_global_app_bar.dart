import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';

AppBar appGlobalAppBar({String? title}) {
  return AppBar(
    title: title == null ? const Text('') : AppText16(title, color: AppColors.primaryText),
  );
}