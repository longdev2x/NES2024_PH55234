import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_quick_result_screen.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_widgets.dart';

class HistoryBmiScreen extends ConsumerWidget {
  const HistoryBmiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.watch(listBMIProvider);
    return Scaffold(
      appBar: appGlobalAppBar('Gần đây'),
      body: fetchList.when(
        data: (objBMIs) {
          if (objBMIs == null || objBMIs.isEmpty) {
            return const Center(
              child: Text('Chưa ghi nhận lịch sử bmi nào'),
            );
          }
          return _buildContent(objBMIs, ref);
        },
        error: (error, stackTrace) => Center(
          child: Text('Error-$error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildContent(List<BMIEntity> list, WidgetRef ref) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        BMIEntity objBMI = list[index];
        BMICategory category = BMIHelper.getBMICategory(objBMI.bmi, objBMI.age);
        return GestureDetector(
          onTap: () {
            ref.read(bmiLocalProvider.notifier).state = objBMI;
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BmiQuickResultScreen(isHistory: true),));
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      AppText20(
                          objBMI.bmi != null ? objBMI.bmi!.toStringAsFixed(2) : 'Không có dữ liệu', fontWeight: FontWeight.bold,),
                      const Spacer(),
                      AppText16(objBMI.formatDate),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: category.color,
                        radius: 10.r,
                      ),
                      SizedBox(width: 5.w),
                      AppText16(category.status),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
