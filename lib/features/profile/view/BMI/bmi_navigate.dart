import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_calculate_screen.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_result_screen.dart';

class BMINavigate extends StatefulWidget {
  const BMINavigate({super.key});

  @override
  State<BMINavigate> createState() => _BMINavigateState();
}

class _BMINavigateState extends State<BMINavigate> {
  final List<Widget> screens = [
    const BMICalculateScreen(),
    const BMIResultScreen(isNav: true),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
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
            label: 'BMI gần nhất'
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
