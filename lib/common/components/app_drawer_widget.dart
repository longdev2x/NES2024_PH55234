import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/infor_card.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/data/repositories/auth_repos.dart';
import 'package:nes24_ph55234/features/application/controller/application_provider.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';

class AppDrawerWidget extends ConsumerStatefulWidget {
  final Function() callBackWhenNavigate;
  const AppDrawerWidget({super.key, required this.callBackWhenNavigate});

  @override
  ConsumerState<AppDrawerWidget> createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends ConsumerState<AppDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final fetchUser = ref.watch(profileProvider);
    final int indexDrawer = ref.watch(drawerIndexProvider);

    return Container(
      height: double.infinity,
      width: 280.w,
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor2,
      ),
      child: Column(
        children: [
          const SafeArea(child: SizedBox()),
          fetchUser.when(
            data: (objUser) => InforNetworkCard(
              onTap: () => Navigator.pushNamed(context, AppRoutesNames.profile),
              avatar: objUser.avatar!,
              title: objUser.username,
              subtitle: objUser.role.name,
            ),
            error: (error, stackTrace) => const Center(child: Text('Error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 32.h, bottom: 16.h),
              child: const AppText16('Chức năng', color: Colors.white),
            ),
          ),
          Column(
            children: [
              AppListTileDrawer(
                onTap: () {
                  ref.read(drawerIndexProvider.notifier).state = 0;
                  widget.callBackWhenNavigate;
                  Navigator.of(context).pushNamed(AppRoutesNames.steps);
                },
                title: 'Đếm số bước chân',
                path: ImageRes.icFoot,
                isActive: indexDrawer == 0,
              ),
              AppListTileDrawer(
                onTap: () {
                  ref.read(drawerIndexProvider.notifier).state = 1;
                  widget.callBackWhenNavigate;
                  Navigator.of(context).pushNamed(AppRoutesNames.grateful);
                },
                title: 'Viết lòng biết ơn',
                path: ImageRes.icLove,
                isActive: indexDrawer == 1,
              ),
              AppListTileDrawer(
                onTap: () {
                  ref.read(drawerIndexProvider.notifier).state = 2;
                  widget.callBackWhenNavigate;
                  Navigator.of(context).pushNamed(AppRoutesNames.sleep);
                },
                title: 'Đo lường giấc ngủ',
                path: ImageRes.icTime,
                isActive: indexDrawer == 2,
              ),
              AppListTileDrawer(
                onTap: () {
                  ref.read(drawerIndexProvider.notifier).state = 3;
                  widget.callBackWhenNavigate;
                  Navigator.of(context).pushNamed(AppRoutesNames.bmi);
                },
                title: 'Chỉ số BMI',
                path: ImageRes.icBMI,
                isActive: indexDrawer == 3,
              ),
              AppListTileDrawer(
                onTap: () {
                  ref.read(drawerIndexProvider.notifier).state = 4;
                  widget.callBackWhenNavigate;
                  Navigator.of(context).pushNamed(AppRoutesNames.yoga);
                },
                title: 'Thiền và Yoga',
                path: ImageRes.icCalo,
                isActive: indexDrawer == 4,
              ),
              fetchUser.when(
                data: (objUser) {
                  return AppListTileDrawer(
                    onTap: () {
                      ref.read(drawerIndexProvider.notifier).state = 5;
                      widget.callBackWhenNavigate;
                      if (objUser.role.value == listRoles[0].value) {
                        Navigator.of(context).pushNamed(AppRoutesNames.adviseUser);
                      } else {
                        Navigator.of(context).pushNamed(AppRoutesNames.adviseExpext);
                      }
                    },
                    title: 'Tư vấn bí mật',
                    path: ImageRes.icAddFriend,
                    isActive: indexDrawer == 5,
                  );
                },
                error: (error, stackTrace) =>
                    const Center(child: Text('Error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
              AppListTileDrawer(
                onTap: () {
                  AuthRepos.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutesNames.auth, (route) => false);
                },
                title: 'Đăng xuất',
                path: ImageRes.icPause,
                isActive: indexDrawer == 6,
              ),
            ],
          )
        ],
      ),
    );
  }
}
