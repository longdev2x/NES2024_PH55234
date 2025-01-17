import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/profile/view/profile/profile_widgets.dart';
import 'package:nes24_ph55234/global.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchUser = ref.watch(profileProvider);
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(30.h), child: AppBar()),
      body: fetchUser.when(
          data: (objUser) {
            return _buildContent(objUser, context);
          },
          error: (error, stackTrace) => Center(child: Text('Error-$error')),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildContent(UserEntity objUser, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.marginHori,
          vertical: AppConstants.marginVeti),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatarWidget(avatar: objUser.avatar),
            SizedBox(height: 15.h),
            AppText20('${objUser.username} (${objUser.role.name})',
                fontWeight: FontWeight.bold),
            SizedBox(height: 5.h),
            AppText16(objUser.email),
            SizedBox(height: 10.h),
            ProfileRowInforWidget(objUser: objUser),
            SizedBox(height: 20.h),
            AppButton(
                ontap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutesNames.editProfile,
                    arguments: true,
                  );
                },
                name: 'Cập nhật hồ sơ',
                width: 250),
            SizedBox(height: 20.h),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ProfileListItem(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutesNames.settings);
                    }, text: 'Cài đặt', icon: ImageRes.icSettings),
                ProfileListItem(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutesNames.rePass, arguments: objUser.email);
                    },
                    text: 'Đổi mật khẩu',
                    icon: ImageRes.icChangPass),
                ProfileListItem(
                    isRight: false,
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Global.storageService.setUserId('');
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutesNames.auth, (route) => false);
                    },
                    text: 'Đăng xuất',
                    icon: ImageRes.icLogout),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
