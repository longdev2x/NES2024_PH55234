import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_drawer_widget.dart';
import 'package:nes24_ph55234/common/components/app_search_bar.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/features/home/view/home_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: homeAppBar(ref, context),
      drawer: const AppDrawerWidget(),
      body: RefreshIndicator(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const HelloText(),
              const UserName(),
              SizedBox(height: 15.h),
              AppSearchBar(onTap: () => Navigator.of(context).pushNamed(AppRoutesNames.search),),
              SizedBox(height: 15.h),
              const HomeBanner(),
              SizedBox(height: 15.h),
              const HomeAnalysisWidget(),
            ],
          ),
        ),
      ),
      onRefresh: () async {
        AppToast.showToast("Fetch lại dữ liệu");
      },
      ),
    );
  }
}
