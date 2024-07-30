import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_widgets.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/history_bmi_screen.dart';

class BmiProfileScreen extends ConsumerWidget {
  const BmiProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchBMI = ref.watch(bmiAsyncProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HistoryBmiScreen(),
                ));
              },
              child: const Text('Xem thêm')),
        ],
      ),
      body: fetchBMI.when(
        data: (objBMI) {
          if (objBMI == null) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.marginHori,
                vertical: AppConstants.marginVeti,
              ),
              child: _buildContent(objBMI, ref),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error-$error'));
        },
        loading: () =>
            const Center(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

Widget _buildContent(BMIEntity objBMI, WidgetRef ref) {
  final BMICategory category = BMIHelper.getBMICategory(objBMI.bmi, objBMI.age);
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
      MoreBMIWidget(age: objBMI.age, currentBMI: objBMI.bmi),
      SizedBox(height: 50.h,),
      AppButton(
        ontap: () {
          ref.read(indexScreenBMI.notifier).state = 1;
        },
        name: 'Tính lại',
      )
    ],
  );
}
