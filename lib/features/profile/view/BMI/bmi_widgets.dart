import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';

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
