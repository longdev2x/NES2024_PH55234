import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/features/step_counter/view/daily_step_screen.dart';
import 'package:nes24_ph55234/features/step_counter/view/steps_counter_screen.dart';

class StepMainTab extends StatefulWidget {
  const StepMainTab({super.key});

  @override
  State<StepMainTab> createState() => _StepMainTabState();
}

class _StepMainTabState extends State<StepMainTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h), // Đặt chiều cao tùy chỉnh ở đây
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              AppText16('Daily Steps'),
              AppText16('Steps Counter'),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [
        DailyStepScreen(),
        StepsCounterScreen(),
      ]),
    );
  }
}
