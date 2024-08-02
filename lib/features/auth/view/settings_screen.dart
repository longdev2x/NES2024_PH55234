import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_theme_switcher.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/auth/controller/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool notify = ref.watch(notifyEnableProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: Column(
          children: [
            const AppText24('Cài đặt'),
            SizedBox(height: 10.h),
            const AppThemeSwitcher(
              height: 126.9,
              width: 194.4,
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: const AppImage(
                imagePath: ImageRes.icNotify,
                width: 24,
                height: 24,
              ),
              title: const Text('Thông báo'),
              trailing: Switch(
                value: notify,
                onChanged: (bool value) {
                  ref.read(notifyEnableProvider.notifier).state = value;
                  _toggleNotifications(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleNotifications(bool enabled) {
    // Logic để bật/tắt thông báo
    if (enabled) {
      // Bật thông báo
    } else {
      // Tắt thông báo
    }
  }
}
