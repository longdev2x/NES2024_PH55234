import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/features/onboarding/controller/onboarding_provider.dart';
import 'package:nes24_ph55234/features/onboarding/view/onboarding_widgets.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/global.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  OnboardingScreen({super.key});
  final PageController controller = PageController();
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreen();
}

class _OnboardingScreen extends ConsumerState<OnboardingScreen> {
  late PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final index = ref.watch(onboardingProvider);
    List<Widget> pages = const [
      OnboardingWidget1(),
      OnboardingWidget2(
        image: ImageRes.peopleNoBackground,
        title: 'Nhiều tính năng hỗ trợ phát triển bản thân',
        subTitle:
            'Theo dõi bước chân theo ngày, viết lòng biết ơn, tính giấc ngủ, BMI, Thiền, Yoga, ... ',
      ),
      OnboardingWidget2(
          image: ImageRes.threePeopleRemoveBg,
          size: 190,
          title: 'Kết nối nhiều bạn bè, hội nhóm cùng đam mê',
          subTitle:
              'Với các tính năng như kết bạn, nhắn tin và tư vấn bí mật.\n   Bắt đầu ngay thôi nào!'),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 25.w),
          child: Stack(
            children: [
              PageView(
                onPageChanged: (value) {
                  ref.read(onboardingProvider.notifier).state = value;
                },
                controller: controller,
                children: pages,
              ),
              Positioned(
                bottom: 0,
                child: Column(children: [
                  DotsIndicator(
                    dotsCount: 3,
                    position: index,
                    decorator: const DotsDecorator(
                      activeColor: AppColors.primaryElement,
                    ),
                    onTap: (position) {
                      controller.animateToPage(position,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                  ),
                  SizedBox(height: 50.h),
                  AppElevatedButton(
                    text: index < pages.length - 1 ? 'NEXT' : 'I\'M READY',
                    onTap: () {
                      if (index < pages.length - 1) {
                        controller.animateToPage(index + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      } else {
                        Global.storageService.setBool(
                            AppConstants.storageDeviceOpenFirstKey, false);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutesNames.auth, (route) => false);
                      }
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
