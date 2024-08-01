import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';

class ProfileAvatarWidget extends ConsumerWidget {
  final String? avatar;
  final bool isMyProfile;
  const ProfileAvatarWidget(
      {super.key, required this.avatar, this.isMyProfile = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoader = ref.watch(loaderProvider);
    return SizedBox(
      height: 150.w,
      width: 150.w,
      child: Stack(
        children: [
          Hero(
            tag: avatar ?? '',
            child: CircleAvatar(
              radius: 100.r,
              backgroundImage: avatar != null
                  ? NetworkImage(avatar!)
                  : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
            ),
          ),
          if (isMyProfile)
            GestureDetector(
              onTap: () async {
                ImagePicker picker = ImagePicker();
                XFile? xFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (xFile == null) return;
                ref
                    .read(profileProvider.notifier)
                    .updateUserProfile(avatarFile: File(xFile.path));
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 40.w,
                  width: 40.w,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      shape: BoxShape.circle),
                  child: const AppIconAsset(path: ImageRes.icCamera),
                ),
              ),
            ),
          if (isLoader)
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}

class ProfileRowInforWidget extends StatelessWidget {
  final UserEntity objUser;
  const ProfileRowInforWidget({super.key, required this.objUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoCard(
          iconPath: ImageRes.icAge,
          label: 'Tuổi',
          value: '${objUser.cacularAge() ?? '...'}',
        ),
        _buildInfoCard(
          iconPath: ImageRes.icHeight,
          label: 'Chiều cao',
          value: '${objUser.height ?? '...'} cm',
        ),
        _buildInfoCard(
          iconPath: ImageRes.icWeight,
          label: 'Cân nặng',
          value: '${objUser.weight ?? '...'} kg',
        ),
        _buildInfoCard(
          iconPath: ImageRes.icBMI,
          label: 'BMI',
          value: objUser.calculateBMI().toStringAsFixed(2)
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required String iconPath,
      required String label,
      required String value}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(iconPath, height: 24, width: 24),
            const SizedBox(height: 5),
            AppText16(label, fontWeight: FontWeight.bold),
            const SizedBox(height: 5),
            AppText14(value),
          ],
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String icon;
  final String text;
  final bool isRight;
  final Function()? onTap;
  const ProfileListItem({
    super.key,
    required this.text,
    required this.icon,
    this.isRight = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Theme.of(context).focusColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppIconAsset(
              path: icon,
              size: 18,
            ),
            SizedBox(width: 20.w),
            AppText16(
              text,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            if (isRight)
              const AppIconAsset(
                path: ImageRes.icArrowRight,
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
}
