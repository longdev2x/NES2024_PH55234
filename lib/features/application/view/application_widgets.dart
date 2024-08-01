import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/features/friend/view/main_friend_screen.dart';
import 'package:nes24_ph55234/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:nes24_ph55234/features/profile/view/profile/profile_screen.dart';
import 'package:nes24_ph55234/features/step/view/main_tab_step.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_screen.dart';
import 'package:rive/rive.dart';

List<String> bottomIcons = [
  ImageRes.home,
  ImageRes.icGroup,
  'assets/icons/play-circle1.png',
  ImageRes.icFoot,
  'assets/icons/person2.png'
];

List<BottomNavigationBarItem> bottomTabs = [
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: ImageRes.home),
      activeIcon: _botttomIcon(
          imagepath: ImageRes.home, color: AppColors.primaryElement),
      label: 'Home'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: ImageRes.icGroup),
      activeIcon: _botttomIcon(
          imagepath: ImageRes.icGroup, color: AppColors.primaryElement),
      label: 'Friend'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: 'assets/icons/play-circle1.png'),
      activeIcon: _botttomIcon(
          imagepath: 'assets/icons/play-circle1.png',
          color: AppColors.primaryElement),
      label: 'Play'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: ImageRes.icFoot),
      activeIcon: _botttomIcon(
          imagepath: ImageRes.icFoot, color: AppColors.primaryElement),
      label: 'Step'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: 'assets/icons/person2.png'),
      activeIcon: _botttomIcon(
          imagepath: 'assets/icons/person2.png',
          color: AppColors.primaryElement),
      label: 'Profile'),
];

Widget _botttomIcon(
    {double height = 18,
    double width = 18,
    required String imagepath,
    Color color = AppColors.primaryFourElementText}) {
  return SizedBox(
    height: height,
    width: width,
    child: AppIconAsset(path: imagepath, iconColor: color),
  );
}

Widget appScreens({int index = 0}) {
  List<Widget> screens = [];
  return screens[index];
}

List<Widget> screens = [
  const HomeScreen(),
  const MainFriendScreen(),
  const YogaScreen(),
  const StepMainTab(),
  const ProfileScreen(),
];



class AnimatedBar extends StatelessWidget {
  final bool isActive;
  const AnimatedBar({
    super.key,
    required this.isActive,
  });


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 4.h),
      height: 4.w,
      width: isActive ? 20.w : 0,
      decoration: BoxDecoration(
        color: const Color(0xFF81B4FF),
        borderRadius: BorderRadius.circular(12)
      ),
    );
  }
}



class HumbergerButton extends StatelessWidget {
  final Function() onTap;
  final Function(Artboard artboard) onInit;
  const HumbergerButton({
    super.key,
    required this.onTap,
    required this.onInit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: 16.w),
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 3), blurRadius: 8),
            ],
          ),
          child: RiveAnimation.asset(
            'assets/rives/humberger_button.riv',
            onInit: onInit,
          ),
        ),
      ),
    );
  }
}

class AppRiverAsset {
  final String src, artboard, stateMachineName, title;
  SMIBool? input;

  AppRiverAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<AppRiverAsset> bottomNavs = [
  AppRiverAsset('assets/rives/icons.riv',
      artboard: 'HOME', stateMachineName: 'HOME_interactivity', title: 'HOME'),
  AppRiverAsset('assets/rives/icons.riv',
      artboard: 'TIMER',
      stateMachineName: 'TIMER_Interactivity',
      title: 'Sleep'),
  AppRiverAsset('assets/rives/icons.riv',
      artboard: 'CHAT', stateMachineName: 'CHAT_Interactivity', title: 'Chat'),
  AppRiverAsset('assets/rives/icons.riv',
      artboard: 'BELL',
      stateMachineName: 'BELL_Interactivity',
      title: 'Notify'),
  AppRiverAsset('assets/rives/icons.riv',
      artboard: 'USER',
      stateMachineName: 'USER_Interactivity',
      title: 'Profile'),
];
