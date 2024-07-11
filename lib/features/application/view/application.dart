import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/components/app_box_decoration.dart';
import 'package:nes24_ph55234/features/application/controller/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/features/application/view/application_widgets.dart';

class ApplicationScreen extends ConsumerWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int index = ref.watch(bottomTabsProvider);
    return Container(
      color: Colors.white,
      child: Scaffold(
          body: screens[index],
          bottomNavigationBar: Container(
            height: 98.h,
            width: 375.w,
            decoration: appBoxShadowWithRadius(),
            child: BottomNavigationBar(
              onTap: (index) {
                ref.read(bottomTabsProvider.notifier).state = index;
              },
              currentIndex: index,
              items: bottomTabs,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.bgButton,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
    );
  }
}
