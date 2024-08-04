import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_music_screen.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_screen.dart';

class YogaMainTab extends StatefulWidget {
  const YogaMainTab({super.key});

  @override
  State<YogaMainTab> createState() => _YogaMainTabState();
}

class _YogaMainTabState extends State<YogaMainTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              AppText16('Video'),
              AppText16('Nhạc'),
            ],
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [
        YogaVideoScreen(),
        YogaMusicScreen(),
      ]),
    );
  }
}
