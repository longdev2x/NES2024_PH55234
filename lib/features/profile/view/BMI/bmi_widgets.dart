import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';

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
    if(age == null || currentBMI == null) {
      return Container();
    }

    final List<BMICategory> categories =
        age! < 20 ? childCategories : adultCategories;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isCurrentCategory = category.isInRange(currentBMI!);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isCurrentCategory ? Colors.blue.withOpacity(0.2) : null,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: category.color,
                radius: 24.r,
              ),
              SizedBox(width: 16.w),
              AppText16(category.status, fontWeight: FontWeight.bold),
              const Spacer(),
              AppText14('${category.minBMI} - ${category.maxBMI}'),
            ],
          ),
        );
      },
    );
  }
}
