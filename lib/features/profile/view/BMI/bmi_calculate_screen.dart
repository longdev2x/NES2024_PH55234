import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_quick_result_screen.dart';

class BMICalculateScreen extends ConsumerStatefulWidget {
  const BMICalculateScreen({super.key});

  @override
  ConsumerState createState() => _BMICalculateScreenState();
}

class _BMICalculateScreenState extends ConsumerState<BMICalculateScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  void _init(UserEntity objUser) {
    if (_weightController.text.isEmpty) {
      _weightController.text = objUser.weight?.toString() ?? '';
    }
    if (_heightController.text.isEmpty) {
      _heightController.text = objUser.height?.toString() ?? '';
    }
    if (_ageController.text.isEmpty) {
      _ageController.text = objUser.age?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: appGlobalAppBar('BMI'),
      body: userAsyncValue.when(
        data: (objUser) {
          print(objUser.id);
          _init(objUser);
          return _buildContent(context, objUser);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserEntity objUser) {
    final notifier = ref.read(profileProvider.notifier);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.marginHori,
            vertical: AppConstants.marginVeti),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText40('Chỉ số hiện tại'),
            SizedBox(height: 60.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160.w,
                  child: AppTextFormField(
                    lable: 'Cân nặng (kg)',
                    controller: _weightController,
                    inputType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: AppTextFormField(
                    controller: _heightController,
                    lable: 'Chiều cao (cm)',
                    inputType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            AppTextFormField(
              controller: _ageController,
              lable: 'Tuổi',
              inputType: TextInputType.number,
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
            const SizedBox(height: 60),
            AppButton(
              ontap: () {
                _calculateBMI(objUser);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BmiQuickResultScreen(),
                  ),
                );
              },
              name: 'Tính BMI',
            ),
          ],
        ),
      ),
    );
  }

  void _calculateBMI(UserEntity objUser) {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);
    if (weight != null && height != null && age != null) {
      final bmi = weight / ((height / 100) * (height / 100));

      ref.read(profileProvider.notifier).updateUserProfile(
            weight: weight,
            height: height,
            age: age,
          );
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
                AppIcon(
                  path: iconPath,
                  iconColor: isChose ? Colors.grey : Colors.white,
                  size: 35,
                ),
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
}
