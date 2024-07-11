import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_theme_switcher.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/features/home/controller/banner_dots_provider.dart';
import 'package:nes24_ph55234/features/home/controller/home_hori_category_provider.dart';
import 'package:nes24_ph55234/features/home/view/home_items.dart';

AppBar homeAppBar(WidgetRef ref, BuildContext context) {
  // final String? avatar = Global.storageService.getUserProfile().name;
  const String? avatar = null;
  return AppBar(
    actions: [
      const AppThemeSwitcher(),
      IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            AppImageWithColor(
              imagePath: avatar,
              width: 26.w,
              height: 26.h,
              color: Colors.black,
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

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    // final String? name = Global.storageService.getUserProfile().name;
    String name = "Hoàng Nhật Long";
    return AppText24(
      name,
      fontWeight: FontWeight.bold,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageController = PageController(initialPage: ref.watch(bannerDotsProvider));
  }

  @override
  Widget build(BuildContext context) {
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
            children: const [
              BannerContainer(imagePath: ImageRes.banner1),
              BannerContainer(imagePath: ImageRes.banner2),
              BannerContainer(imagePath: ImageRes.banner3),
            ],
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
          dotsCount: 3,
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
          color: AppColors.primaryText,
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
      ImageRes.banner1,
      ImageRes.banner2,
      ImageRes.banner3,
      ImageRes.banner1,
      ImageRes.banner2,
      ImageRes.banner3,
      ImageRes.banner1,
      ImageRes.banner2,
      ImageRes.banner3,
      ImageRes.banner1,
    ];

    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
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
