import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/features/steps_counter/view/daily_steps_screen.dart';
import 'package:nes24_ph55234/features/steps_counter/view/steps_counter_screen.dart';

class StepsMainTab extends StatefulWidget {
  const StepsMainTab({super.key});

  @override
  State<StepsMainTab> createState() => _StepsMainTabState();
}

class _StepsMainTabState extends State<StepsMainTab>
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
      appBar: AppBar(
        bottom: TabBar(controller: _tabController, tabs: const [
          AppText16('Daily Steps'),
          AppText16('Steps Counter'),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: const [
        DailyStepsScreen(),
        StepsCounterScreen(),
      ]),
    );
  }
}
