import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_widgets.dart';

class BmiQuickResultScreen extends ConsumerWidget {
  final bool isHistory;
  const BmiQuickResultScreen({super.key, this.isHistory = false});

  @override
  Widget build(context, WidgetRef ref) {
    final objBMI = ref.watch(bmiLocalProvider);
    return Scaffold(
      appBar: AppBar(),
      body: objBMI == null
          ? const Center(
              child: Text('Không có dữ liệu'),
            )
          : SizedBox(
              height: 1.sh,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.marginHori,
                        vertical: AppConstants.marginVeti,
                      ),
                      child: _buildContent(objBMI, isHistory),
                    ),
                  ),
                  if (!isHistory)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.h),
                        child: AppButton(
                          height: 50,
                          width: 325,
                          ontap: () {
                            ref.read(bmiAsyncProvider.notifier).addBMI(
                                  BMIEntity(
                                      userId: objBMI.userId,
                                      date: objBMI.date,
                                      bmi: objBMI.bmi,
                                      age: objBMI.age,
                                      height: objBMI.height,
                                      weight: objBMI.weight,
                                      gender: objBMI.gender),
                                );
                            ref.read(indexScreenBMI.notifier).state = 1;
                            Navigator.pop(context);
                          },
                          name: 'Lưu',
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildContent(BMIEntity objBMI, bool isHistory) {
    final BMICategory category =
        BMIHelper.getBMICategory(objBMI.bmi, objBMI.age);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppText24('BMI của bạn là ...', fontWeight: FontWeight.bold),
        SizedBox(height: 6.h),
        objBMI.bmi != null
            ? AppText55(
                objBMI.bmi?.toStringAsFixed(2),
                fontWeight: FontWeight.w900,
              )
            : const SizedBox(),
        SizedBox(height: 12.h),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            category.status,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(height: 8.h),
        AppText16(
            '${objBMI.weight} kg | ${objBMI.height} cm | ${objBMI.gender} | ${objBMI.age} tuổi'),
        AdViseWidget(advise: category.advise),
        SizedBox(height: 10.h),
        if (isHistory) AppText16(objBMI.formatDate),
      ],
    );
  }
}
