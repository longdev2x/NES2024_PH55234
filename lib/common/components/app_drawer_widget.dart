import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/auth_repos.dart';
import 'package:nes24_ph55234/global.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310.w,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(top: 70.h, left: 20.w),
            child: Text(
              "Nes2024 PH55234",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              _pop(context);
              Navigator.of(context).pushNamed(AppRoutesNames.steps);
            },
            leading: const Icon(Icons.directions_walk),
            title: const Text('Đếm số bước chân'),
          ),
          ListTile(
            onTap: () {
              _pop(context);
              Navigator.pushNamed(context, AppRoutesNames.grateful);
            },
            leading: const Icon(Icons.heart_broken),
            title: const Text('Viết lòng biết ơn'),
          ),
          ListTile(
            onTap: () {
              _pop(context);
            },
            leading: const Icon(Icons.alarm),
            title: const Text('Đo lường giấc ngủ'),
          ),
          ListTile(
            onTap: () {
              _pop(context);
              Navigator.of(context).pushNamed(AppRoutesNames.yoga);
            },
            leading: const Icon(Icons.video_collection_outlined),
            title: const Text('Video Thiền và Yoga'),
          ),
          ListTile(
            onTap: () {
              _pop(context);
              Navigator.of(context).pushNamed(AppRoutesNames.bmi);
            },
            leading: const Icon(Icons.east),
            title: const Text('BMI'),
          ),
          ListTile(
            onTap: () {
              String role = Global.storageService.getRole();
              if (role == listRoles[0].name) {
                _pop(context);
                Navigator.of(context).pushNamed(AppRoutesNames.adviseUser);
              } else {
                _pop(context);
                Navigator.of(context).pushNamed(AppRoutesNames.adviseExpext);
              }
            },
            leading: const Icon(Icons.call),
            title: const Text('Tư vấn bí mật'),
          ),
          ListTile(
            onTap: () {
              AuthRepos.signOut();
            },
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
          ),
        ],
      ),
    );
  }

  void _pop(BuildContext context) {
    Navigator.pop(context);
  }
}
