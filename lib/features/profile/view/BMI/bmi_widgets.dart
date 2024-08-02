import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_quick_result_screen.dart';

class ProfileBMIInputWidget extends ConsumerWidget {
  final bool isBMI;
  final UserEntity objUser;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController bithController;

  const ProfileBMIInputWidget({
    super.key,
    required this.objUser,
    this.isBMI = false,
    required this.weightController,
    required this.heightController,
    required this.bithController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileProvider.notifier);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160.w,
              child: AppTextFormField(
                lable: 'Cân nặng (kg)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Chỉ nhập số cân';
                  }
                  double? weight = double.tryParse(value);
                  if (weight == null || weight > 200 || weight < 5) {
                    return 'Không hợp lệ';
                  }
                  return null;
                },
                controller: weightController,
                inputType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 160.w,
              child: AppTextFormField(
                controller: heightController,
                lable: 'Chiều cao (cm)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Chỉ nhập số chiều cao(cm)';
                  }
                  double? height = double.tryParse(value);
                  if (height == null || height > 300 || height < 30) {
                    return 'Không hợp lệ';
                  }
                  return null;
                },
                inputType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        AppTextFormField(
          lable: 'Ngày sinh (${objUser.cacularAge()} tuổi)',
          validator: (value) {
            if (objUser.cacularAge() == null || objUser.cacularAge()! < 5) {
              return 'Ứng dụng cho trẻ từ 5 tuổi';
            }
            return null;
          },
          controller: bithController,
          readOnly: true,
          onTap: () {
            _showDatePicker(context, objUser, ref);
          },
        ),
        SizedBox(height: 50.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _genderPicker(
                onTap: () {
                  notifier.updateUserProfile(gender: 'Nam');
                },
                iconPath: ImageRes.icGenderMan,
                text: 'Nam',
                isChose: objUser.gender == 'Nam'),
            _genderPicker(
                onTap: () {
                  notifier.updateUserProfile(gender: 'Nữ');
                },
                iconPath: ImageRes.icGenderWoman,
                text: 'Nữ',
                isChose: objUser.gender == 'Nữ'),
          ],
        ),
        if (isBMI)
          Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: AppButton(
              ontap: () {
                _calculateBMI(objUser, ref);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BmiQuickResultScreen(),
                  ),
                );
              },
              name: 'Tính BMI',
            ),
          ),
      ],
    );
  }

  void _showDatePicker(
      BuildContext context, UserEntity objUser, WidgetRef ref) async {
    DateTime? bith = await showDatePicker(
      context: context,
      locale: const Locale('vi', 'VN'),
      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
      lastDate: DateTime.now(),
      initialDate: DateTime.now().subtract(const Duration(days: 7300)),
    );
    ref.read(profileProvider.notifier).updateUserProfile(bith: bith);
  }

  Widget _genderPicker({
    required Function() onTap,
    bool isChose = false,
    required String iconPath,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 85.h,
            width: 160.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: isChose ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIconAsset(
                  path: iconPath,
                  iconColor: Colors.black,
                  size: 35,
                ),
                SizedBox(height: 3.h),
                AppText16(text)
              ],
            ),
          ),
          isChose
              ? Positioned(
                  top: 5.h,
                  right: 5.w,
                  child: const AppImage(
                    imagePath: ImageRes.icCheckTick,
                    height: 30,
                    width: 30,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _calculateBMI(UserEntity objUser, WidgetRef ref) {
    final weight = double.tryParse(weightController.text);
    final height = double.tryParse(heightController.text);
    final age = objUser.cacularAge();

    if (weight != null && height != null && age != null) {
      final bmi = weight / ((height / 100) * (height / 100));

      ref.read(profileProvider.notifier).updateUserProfile(
          weight: weight, height: height, bith: objUser.bith, bmi: bmi);
      ref.read(bmiLocalProvider.notifier).state = BMIEntity(
          userId: objUser.id,
          date: DateTime.now(),
          bmi: bmi,
          age: age,
          height: height,
          weight: weight,
          gender: objUser.gender);
    }
  }
}

class AdViseWidget extends StatelessWidget {
  final String advise;
  const AdViseWidget({super.key, required this.advise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: AppText20(
        advise,
        maxLines: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MoreBMIWidget extends StatelessWidget {
  final int? age;
  final double? currentBMI;

  const MoreBMIWidget({Key? key, required this.age, required this.currentBMI})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (age == null || currentBMI == null) {
      return Container();
    }

    final List<BMICategory> categories =
        age! < 20 ? childCategories : adultCategories;

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isCurrentCategory = category.isInRange(currentBMI!);

          return Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isCurrentCategory
                  ? const Color.fromARGB(255, 64, 128, 30).withOpacity(0.8)
                  : null,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: category.color,
                  radius: 6.r,
                ),
                SizedBox(width: 12.w),
                AppText16(
                  category.status,
                  fontWeight:
                      isCurrentCategory ? FontWeight.w900 : FontWeight.w500,
                  color: isCurrentCategory ? Colors.white : null,
                ),
                const Spacer(),
                AppText14('${category.minBMI} - ${category.maxBMI}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BMIHelper {
  static BMICategory getBMICategory(double? bmi, int? age) {
    if (bmi == null || age == null) {
      return BMICategory(
          status: 'Không đủ dữ kiện',
          minBMI: 0,
          maxBMI: 0,
          color: Colors.black,
          advise:
              'Vui lòng thêm cân nặng, chiều cao và tuổi tác để tính toán chỉ số');
    }
    if (age >= 20) {
      BMICategory category =
          adultCategories.firstWhere((category) => category.isInRange(bmi));
      return category;
    } else {
      BMICategory category =
          childCategories.firstWhere((category) => category.isInRange(bmi));
      return category;
    }
  }
}
