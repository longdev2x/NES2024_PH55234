import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_widgets.dart';

class BMIResultScreen extends ConsumerStatefulWidget {
  final bool isNav;
  const BMIResultScreen({super.key, required this.isNav});

  @override
  ConsumerState<BMIResultScreen> createState() => _BMIResultScreenState();
}

class _BMIResultScreenState extends ConsumerState<BMIResultScreen> {
  @override
  Widget build(BuildContext context) {
    final fetchUser = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.marginHori,
          vertical: AppConstants.marginVeti,
        ),
        child: fetchUser.when(
          data: (objUser) {
            return _buildContent(objUser, isNav: widget.isNav);
          },
          error: (error, stackTrace) => Center(child: Text('Error-$error')),
          loading: () =>
              const Center(child: Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}

Widget _buildContent(UserEntity objUser, {required bool isNav}) {
  final BMICategory category = _getBMICategory(objUser.bmi, objUser.age);
  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppText28('BMI của bạn là ...', fontWeight: FontWeight.bold),
        SizedBox(height: 10.h),
        AppText34(
          objUser.bmi?.toStringAsFixed(2),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 10.h),
        ElevatedButton(
          onPressed: () {},
          child: Text(category.status),
        ),
        SizedBox(height: 10.h),
        AppText16(
            '${objUser.weight} kg | ${objUser.height} cm | ${objUser.gender} | ${objUser.age} tuổi'),
        if (!isNav)
          AdViseWidget(
            advise: category.advise,
          ),
        if (isNav) MoreBMIWidget(age: objUser.age, currentBMI: objUser.bmi),
      ],
    ),
  );
}

BMICategory _getBMICategory(double? bmi, int? age) {
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
