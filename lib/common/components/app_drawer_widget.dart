import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/auth_repos.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/global.dart';

class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchUser = ref.watch(profileProvider);
    return Drawer(
      width: 310.w,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            fetchUser.when(
              data: (objUser) {
                return DrawerHeader(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35.r,
                          backgroundImage: objUser.avatar != null 
                          ? NetworkImage(objUser.avatar!)
                          : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
                        ),
                        SizedBox(height: 2.h),
                        AppText20(objUser.username, fontWeight: FontWeight.bold),
                        AppText16('BMI: ${objUser.calculateBMI().toStringAsFixed(1)}', fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error - $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            _buildListTile(
              context,
              icon: Icons.directions_walk,
              title: 'Đếm số bước chân',
              routeName: AppRoutesNames.steps,
            ),
            _buildListTile(
              context,
              icon: Icons.book,
              title: 'Viết lòng biết ơn',
              routeName: AppRoutesNames.grateful,
            ),
            _buildListTile(
              context,
              icon: Icons.video_collection_outlined,
              title: 'Video Thiền và Yoga',
              routeName: AppRoutesNames.yoga,
            ),
            _buildListTile(
              context,
              icon: Icons.health_and_safety,
              title: 'BMI',
              routeName: AppRoutesNames.bmi,
            ),
            _buildListTile(
              context,
              icon: Icons.alarm,
              title: 'Đo lường giấc ngủ',
              routeName: AppRoutesNames.sleep,
            ),
            _buildListTile(
              context,
              icon: Icons.message,
              title: 'Tư vấn bí mật',
              routeName: Global.storageService.getRole() == listRoles[0].name
                  ? AppRoutesNames.adviseUser
                  : AppRoutesNames.adviseExpext,
            ),
            _buildListTile(
              context,
              icon: Icons.logout,
              title: 'LogOut',
              onTap: () => AuthRepos.signOut(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? routeName,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: () {
        _pop(context);
        if (onTap != null) {
          onTap();
        } else if (routeName != null) {
          Navigator.of(context).pushNamed(routeName);
        }
      },
      leading: Icon(icon,
          color: AppColors.primaryElement.withOpacity(0.9), size: 28.w),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
    );
  }

  void _pop(BuildContext context) {
    Navigator.pop(context);
  }
}
