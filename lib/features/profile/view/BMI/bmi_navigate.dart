import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_calculate_screen.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_profile_screen.dart';

final List<Widget> screens = [
  const BmiProfileScreen(),
  const BMICalculateScreen(),
];

class BMINavigate extends ConsumerWidget {
  const BMINavigate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(indexScreenBMI);
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: AppIconAsset(
                path: ImageRes.icBMI,
              ),
              label: 'BMI gần nhất'),
          BottomNavigationBarItem(
              icon: AppIconAsset(
                path: ImageRes.icCalculate,
              ),
              label: 'Tính toán'),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(indexScreenBMI.notifier).state = index;
        },
      ),
    );
  }
}
