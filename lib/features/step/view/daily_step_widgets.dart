import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/features/step/controller/step_target_provider.dart';

class StepMainCircle extends ConsumerWidget {
  final StepEntity objStep;
  const StepMainCircle({super.key, required this.objStep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchTargetStepDaily =
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeStepDaily));
    return AppCircularProgressContent(
      step: objStep.step,
      targetStep: fetchTargetStepDaily.when(
          data: (objTarget) => objTarget!.target.toInt(),
          error: (e, s) => 0,
          loading: () => 2500),
      date: 'Hôm qua',
      iconPath: ImageRes.icWalk,
    );
  }
}

class StepRowMoreInfor extends ConsumerWidget {
  final StepEntity objStep;
  final int targetCaloreis = 100;
  final int targetMinute = 100;
  const StepRowMoreInfor({super.key, required this.objStep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchTargetMetree =
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeMetreDaily));
    final fetchTargeCalo =
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeCaloDaily));
    final fetchTargetMinute =
        ref.watch(stepTargetAsyncFamilyProvider(AppConstants.typeMinuteDaily));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          fetchTargetMetree.when(
            data: (data) {
              print('zzzzzz-${data?.target}');
              final percentMetre =
                  (objStep.metre / (data?.target ?? 100)).clamp(0.0, 1.0);
              return AppCircularProgressIcon(
                percent: percentMetre,
                iconPath: ImageRes.icArrowRight,
                title: '${objStep.metre} m',
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => AppCircularProgressIcon(
              iconPath: ImageRes.icArrowRight,
              title: '${objStep.metre} m',
              percent: 0,
            ),
          ),
          fetchTargeCalo.when(
              data: (data) {
                print('zzzzzz-${data?.target}');
                final percentKacl =
                    (objStep.calo / (data?.target ?? 100)).clamp(0.0, 1.0);
                return AppCircularProgressIcon(
                  percent: percentKacl,
                  iconPath: ImageRes.icCalo,
                  title: '${objStep.calo} kcal',
                );
              },
              error: (error, stackTrace) => const Text('Error'),
              loading: () => AppCircularProgressIcon(
                    iconPath: ImageRes.icCalo,
                    title: '${objStep.calo} kcal',
                    percent: 0,
                  )),
          fetchTargetMinute.when(
            data: (data) {
              print('zzzzzz-${data?.target}');
              final percentMinute =
                  (objStep.minute / (data?.target ?? 100)).clamp(0.0, 1.0);
              return AppCircularProgressIcon(
                percent: percentMinute,
                iconPath: ImageRes.icTime,
                title: '${objStep.minute} phút',
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => AppCircularProgressIcon(
              iconPath: ImageRes.icTime,
              title: '${objStep.minute} phút',
              percent: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class StepLineChart extends StatelessWidget {
  const StepLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.h,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 10,
          // backgroundColor: Colors.black
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 2),
                const FlSpot(1, 4),
                const FlSpot(2, 3),
                const FlSpot(3, 2),
                const FlSpot(4, 5),
                const FlSpot(5, 9),
                const FlSpot(6, 7),
              ],
              isCurved: true,
              gradient: const LinearGradient(colors: [
                Colors.purple,
                Colors.pink,
              ]),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(colors: [
                  Colors.purple.withOpacity(0.2),
                  Colors.pink.withOpacity(0.2),
                ]),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 0.r,
                    color: Colors.white,
                    strokeWidth: 5.r,
                    strokeColor: Colors.black,
                  );
                },
              ),
            ),
          ],
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: false,
            getDrawingVerticalLine: (value) {
              return const FlLine(color: Colors.transparent);
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 12,
                getTitlesWidget: (value, meta) {
                  return AppText10(value != 0 ? value.toInt().toString() : '');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
