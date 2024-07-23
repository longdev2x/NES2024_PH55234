import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_calculate_screen.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_profile_screen.dart';

final List<Widget> screens = [
  const BMICalculateScreen(),
  const BmiProfileScreen(),
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
              icon: AppIcon(
                path: ImageRes.icCalculate,
              ),
              label: 'Tính toán'),
          BottomNavigationBarItem(
              icon: AppIcon(
                path: ImageRes.icBMI,
              ),
              label: 'BMI gần nhất'),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(indexScreenBMI.notifier).state = index;
        },
      ),
    );
  }
}
