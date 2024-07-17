import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/features/step/controller/step_counter_provider.dart';

class HistoryStepCounterScreen extends ConsumerWidget {
  const HistoryStepCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchList = ref.watch(historyStepCounterProvier);
    return Scaffold(
      appBar: appGlobalAppBar('Lịch sử đi bộ'),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: fetchList.when(
          data: (data) {
            if (data == null || data.isEmpty) {
              return const Center(
                child: Text('Chưa ghi nhận buổi chạy nào'),
              );
            }
            return Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  StepEntity objStep = data[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                      child: Row(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText16('Số bước: ${objStep.step.toString()} bước'),
                            SizedBox(height: 5.h),
                            AppText16('Khoảng cách: ${objStep.metre.toString()} met'),
                            SizedBox(height: 5.h),
                            AppText16('Date: ${objStep.formatDate}'),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText16('Số Calo: ${objStep.calo.toString()} kcal'),
                            SizedBox(height: 5.h),
                            AppText16('Số phút: ${objStep.minute.toString()} phút'),
                          ],
                        ),
                      ]),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) => const Text('Error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
