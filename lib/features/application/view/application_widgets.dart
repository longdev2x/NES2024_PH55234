import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/features/friend/view/friend_screen.dart';
import 'package:nes24_ph55234/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:nes24_ph55234/features/profile/view/profile_screen.dart';
import 'package:nes24_ph55234/features/search/view/search_screen.dart';

List<BottomNavigationBarItem> bottomTabs = [
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: ImageRes.home),
      activeIcon: _botttomIcon(
          imagepath: ImageRes.home, color: AppColors.primaryElement),
      label: 'Home'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: ImageRes.search),
      activeIcon: _botttomIcon(
          imagepath: ImageRes.search, color: AppColors.primaryElement),
      label: 'Search'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: 'assets/icons/play-circle1.png'),
      activeIcon: _botttomIcon(
          imagepath: 'assets/icons/play-circle1.png',
          color: AppColors.primaryElement),
      label: 'Play'),
  BottomNavigationBarItem(
      icon: _botttomIcon(imagepath: ImageRes.message),
      activeIcon: _botttomIcon(
          imagepath: ImageRes.message, color: AppColors.primaryElement),
      label: 'Message'),
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
    child: AppIconWithBgColor(imagePath: imagepath, color: color),
  );
}

Widget appScreens({int index = 0}) {
  List<Widget> screens = [];
  return screens[index];
}

List<Widget> screens = [
  const HomeScreen(),
  const SearchScreen(),
  const FriendScreen(),
  const Center(
      child: Text('Tin nhắn + Tư vấn bí mật',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
  const ProfileScreen(),
];
