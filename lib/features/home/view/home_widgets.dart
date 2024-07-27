import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_theme_switcher.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/home/controller/banner_dots_provider.dart';
import 'package:nes24_ph55234/features/home/controller/home_hori_category_provider.dart';
import 'package:nes24_ph55234/features/home/view/home_items.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';

AppBar homeAppBar(WidgetRef ref, BuildContext context) {
  final fetchUser = ref.watch(profileProvider);
  return AppBar(
    actions: [
      const AppThemeSwitcher(),
      IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutesNames.search);
          },
          icon: const Icon(Icons.search)),
      GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            fetchUser.when(
              data: (objUser) => CircleAvatar(
                backgroundImage: objUser.avatar != null
                    ? NetworkImage(objUser.avatar!)
                    : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
              ),
              error: (error, stackTrace) => const Center(child: Text('Error')),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      )
    ],
  );
}

class HelloText extends StatelessWidget {
  const HelloText({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppText24('Hello,',
        color: AppColors.primaryFourElementText, fontWeight: FontWeight.bold);
  }
}

class UserName extends ConsumerWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchUser = ref.watch(profileProvider);
    return fetchUser.when(
      data: (objUser) => AppText24(
        objUser.username,
        fontWeight: FontWeight.bold,
      ),
      error: (error, stackTrace) => const Center(child: Text('Error')),
      loading: () => const Center(
        child: SizedBox(),
      ),
    );
  }
}

class HomeBanner extends ConsumerStatefulWidget {
  const HomeBanner({super.key});

  @override
  ConsumerState<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends ConsumerState<HomeBanner> {
  late PageController pageController;
  int _currentIndex = 0;
  Timer? timer;

  final List<BannerContainer> list = const [
    BannerContainer(imagePath: ImageRes.stepCounterBanner),
    BannerContainer(imagePath: ImageRes.sleepBanner),
    BannerContainer(imagePath: ImageRes.gratefulBanner),
    BannerContainer(imagePath: ImageRes.bmiBanner),
    BannerContainer(imagePath: ImageRes.yogaBanner),
    BannerContainer(imagePath: ImageRes.adviseBanner),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageController = PageController(initialPage: ref.watch(bannerDotsProvider));
    _startAutoScroll();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_currentIndex < list.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      ref.read(bannerDotsProvider.notifier).changIndex(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentIndex = ref.watch(bannerDotsProvider);
    return Column(
      children: [
        // banner
        SizedBox(
          width: 325.w,
          height: 160.h,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              ref.read(bannerDotsProvider.notifier).changIndex(index);
            },
            children: list,
          ),
        ),
        SizedBox(height: 5.h),
        //dots
        DotsIndicator(
          onTap: (position) {
            pageController.animateToPage(position,
                duration: const Duration(microseconds: 300),
                curve: Curves.bounceIn);
          },
          position: ref.watch(bannerDotsProvider),
          dotsCount: list.length,
          decorator: DotsDecorator(
            size: const Size.square(9),
            activeSize: const Size(20, 8),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.w),
            ),
            color: AppColors.primaryFourElementText,
            activeColor: AppColors.primaryElement,
          ),
        ),
      ],
    );
  }
}

class BannerContainer extends StatelessWidget {
  const BannerContainer({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325.h,
      width: 160.h,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(28)),
    );
  }
}

class HomeMenuBar extends ConsumerWidget {
  const HomeMenuBar({super.key});

  void _updateFilter(WidgetRef ref, int index) =>
      ref.read(homeHoriCategoryProvider.notifier).state = listCategory[index];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String categoryChosed = ref.watch(homeHoriCategoryProvider);
    //filter theo list để sổ xuống
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText16(
          'Các tính năng',
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 50.h,
          child: ListView.builder(
              itemCount: listCategory.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return CategoryHoriItem(
                    onPressed: () => _updateFilter(ref, index),
                    name: listCategory[index],
                    isChose: categoryChosed == listCategory[index]);
              }),
        ),
      ],
    );
  }
}

class CourseItemGrid extends ConsumerWidget {
  const CourseItemGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listImage = [
      ImageRes.sleepBanner,
      ImageRes.bmiBanner,
      ImageRes.gratefulBanner,
      ImageRes.yogaBanner,
      ImageRes.stepCounterBanner,
      ImageRes.adviseBanner
    ];

    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: listImage.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (ctx, index) {
        return AppImageWithColor(
          width: 40,
          height: 40,
          onTap: () async {
            AppToast.showToast("Vào màn hình detail");
          },
          imagePath: listImage[index],
          boxFit: BoxFit.fitWidth,
        );
      },
    );
  }
}
