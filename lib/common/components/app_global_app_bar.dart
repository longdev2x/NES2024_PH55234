import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';

AppBar appGlobalAppBar(String? title, {List<Widget>? actions}) {
  return AppBar(
    title: title == null ? const Text('') : AppText16(title),
    actions: actions,
  );
}