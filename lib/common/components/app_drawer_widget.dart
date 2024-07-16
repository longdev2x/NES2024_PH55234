import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/data/repositories/auth_repos.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310.w,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(top: 60.h, left: 10.w),
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
              Navigator.of(context).pushNamed(AppRoutesNames.steps);
            },
            leading: const Icon(Icons.star),
            title: const Text('Đếm số bước chân'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.one_k),
            title: const Text('Viết lòng biết ơn'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.category),
            title: const Text('Đo lường giấc ngủ'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutesNames.yoga);
            },
            leading: const Icon(Icons.mode),
            title: const Text('Video Thiền và Yoga'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.u_turn_right),
            title: const Text('Tư vấn bí mật'),
          ),
          ListTile(
            onTap: () {
              AuthRepos.signOut();
            },
            leading: const Icon(Icons.outbox),
            title: const Text('LogOut'),
          ),
        ],
      ),
    );
  }
}
