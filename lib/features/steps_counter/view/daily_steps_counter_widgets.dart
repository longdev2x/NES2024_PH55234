import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';

class StepsMainCircle extends StatelessWidget {
  const StepsMainCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCircularProgressContent(
      steps: 1000,
      targetSteps: 1500,
      date: 'Hôm qua',
      iconPath: ImageRes.clap,
    );
  }
}

class StepsRowMoreInfor extends StatelessWidget {
  const StepsRowMoreInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.r),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppCircularProgressIcon(
            percent: 0.4,
            iconPath: ImageRes.icBirth,
            title: '2 km',
          ),
          AppCircularProgressIcon(
            percent: 0.6,
            iconPath: ImageRes.icWork,
            title: '75 kcal',
          ),
          AppCircularProgressIcon(
            percent: 0.4,
            iconPath: ImageRes.icAlarm,
            title: '56 phút',
          ),
        ],
      ),
    );
  }
}

class StepsLineChart extends StatelessWidget {
  const StepsLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 10,
          backgroundColor: Colors.black,
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 2),
                const FlSpot(1, 3),
                const FlSpot(2, 3),
                const FlSpot(3, 3.4),
                const FlSpot(4, 3),
                const FlSpot(5, 3),
                const FlSpot(6, 5),
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
              dotData: const FlDotData(show: false),
            ),
          ],
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: false,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.shade800,
                strokeWidth: 0.8,
              );
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
