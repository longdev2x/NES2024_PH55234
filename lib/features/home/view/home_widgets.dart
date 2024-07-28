import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_circular_progress.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/components/app_theme_switcher.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/sleep_entity.dart';
import 'package:nes24_ph55234/data/models/step_entity.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/features/application/controller/application_provider.dart';
import 'package:nes24_ph55234/features/home/controller/all_target_provider.dart';
import 'package:nes24_ph55234/features/home/controller/banner_dots_provider.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/sleep/controller/sleep_provider.dart';
import 'package:nes24_ph55234/features/step/controller/daily_step_provider.dart';

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
              data: (objUser) => GestureDetector(
                onTap: () {
                  ref.read(bottomTabsProvider.notifier).state = 4;
                },
                child: CircleAvatar(
                  backgroundImage: objUser.avatar != null
                      ? NetworkImage(objUser.avatar!)
                      : const AssetImage(ImageRes.avatarDefault) as ImageProvider,
                ),
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

class HomeAnalysisWidget extends ConsumerWidget {
  const HomeAnalysisWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchTarget = ref.watch(allTargetProvider);
    final fetchStep = ref.watch(dailyStepProvider);
    final fetchProfile = ref.watch(profileProvider);
    final List<SleepEntity> listSleeps = ref.watch(sleepProvider);

    return fetchTarget.when(
      data: (targets) {
        return fetchProfile.when(
          data: (profile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText20('Thành tích', fontWeight: FontWeight.bold),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              HomeSetTargetWidget(targets: targets),
                        );
                      },
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                        ),
                      ),
                      child: const AppText16(
                        'Đặt lại mục tiêu',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ...targets.map((target) {
                  switch (target.type) {
                    case AppConstants.typeStepDaily:
                      return _buildStepCard(fetchStep, target);
                    case AppConstants.typeHoursSleep:
                      if (listSleeps.isEmpty || listSleeps.first.endTime == null) {
                        return HomeCardPriviewItem(
                          title: 'Giấc ngủ',
                          subtile: 'giờ',
                          result: 0,
                          target: target.target,
                        );
                      }
                      return HomeCardPriviewItem(
                        title: 'Giấc ngủ',
                        subtile: 'giờ',
                        result: listSleeps.first.endTime!
                            .difference(listSleeps.first.startTime!)
                            .inHours
                            .toDouble(),
                        target: target.target,
                      );
                    case AppConstants.typeHeight:
                      return HomeCardPriviewItem(
                        title: 'Chiều cao',
                        subtile: 'cm',
                        result: profile.height ?? 0,
                        target: target.target,
                      );
                    case AppConstants.typeWeight:
                      return HomeCardPriviewItem(
                        title: 'Cân nặng',
                        subtile: 'kg',
                        result: profile.weight ?? 0,
                        target: target.target,
                      );
                    case AppConstants.typeBMI:
                      return HomeCardPriviewItem(
                        title: 'BMI',
                        subtile: 'kg/m2',
                        result: profile.calculateBMI(),
                        target: target.target,
                      );
                    default:
                      return const SizedBox();
                  }
                }).toList(),
              ],
            );
          },
          error: (e, s) => const Center(child: Text('Profile Error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) => Center(child: Text('Target Error - $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStepCard(
      AsyncValue<List<StepEntity>> fetchStep, TargetEntity target) {
    return fetchStep.when(
      data: (steps) {
        StepEntity todayStep = steps.last;
        return HomeCardPriviewItem(
          title: 'Đi bộ',
          subtile: 'bước',
          result: todayStep.step.toDouble(),
          target: target.target,
        );
      },
      error: (e, s) => const Center(child: Text('Step Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class HomeCardPriviewItem extends ConsumerWidget {
  final String title;
  final String subtile;
  final double result;
  final double target;
  const HomeCardPriviewItem({
    super.key,
    required this.title,
    required this.subtile,
    required this.result,
    required this.target,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(allTargetProvider);
    final double percent = (result / target).clamp(0.0, 1.0);
    return Card(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Padding(
        padding:
            EdgeInsets.only(left: 12.w, right: 20.w, top: 10.h, bottom: 10.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText20(
                  title,
                  fontWeight: FontWeight.bold,
                ),
                AppText16('Mục tiêu ${target.toInt()} $subtile'),
              ],
            ),
            const Spacer(),
            AppProgresTarget(
              name: result.toInt().toString(),
              percent: percent,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSetTargetWidget extends ConsumerStatefulWidget {
  final List<TargetEntity> targets;
  const HomeSetTargetWidget({super.key, required this.targets});

  @override
  ConsumerState<HomeSetTargetWidget> createState() =>
      _HomeSetTargetWidgetState();
}

class _HomeSetTargetWidgetState extends ConsumerState<HomeSetTargetWidget> {
  late final List<TargetEntity> targets;
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _stepsController;
  late final TextEditingController _hoursController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _bmiController;
  double? step;
  double? height;
  double? hours;
  double? weight;
  double? bmi;

  @override
  void initState() {
    super.initState();
    targets = widget.targets;
    _stepsController = TextEditingController();
    _hoursController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _bmiController = TextEditingController();

    if (targets.isEmpty) return;
    for (TargetEntity target in targets) {
      switch (target.type) {
        case AppConstants.typeStepDaily:
          _stepsController.text = target.target.toInt().toString();
          break;
        case AppConstants.typeHoursSleep:
          _hoursController.text = target.target.toStringAsFixed(1);
          break;
        case AppConstants.typeHeight:
          _heightController.text = target.target.toInt().toString();
          break;
        case AppConstants.typeWeight:
          _weightController.text = target.target.toStringAsFixed(1);
          break;
        case AppConstants.typeBMI:
          _bmiController.text = target.target.toStringAsFixed(1);
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stepsController.dispose();
    _hoursController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bmiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(width: 300.w),
            const AppText24(
              'Đặt mục tiêu',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.w),
            AppTextFormField(
              controller: _stepsController,
              lable: 'Số bước /ngày',
              validator: (value) {
                step = double.tryParse(value ?? '');
                if (step == null) {
                  return 'Hãy chỉ nhập số';
                }
                if (step! < 100) {
                  return 'Hãy đặt mục tiêu từ 100 nhé';
                }
                return null;
              },
              inputType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            AppTextFormField(
              controller: _hoursController,
              lable: 'Số giờ ngủ (giờ /ngày)',
              validator: (value) {
                hours = double.tryParse(value ?? '');
                if (hours == null) {
                  return 'Hãy chỉ nhập số';
                }
                if (hours! < 5) {
                  return 'Đừng ngủ dưới 5 tiếng nhé!';
                }
                return null;
              },
              inputType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            AppTextFormField(
              controller: _heightController,
              lable: 'Chiều cao (cm)',
              validator: (value) {
                height = double.tryParse(value ?? '');
                if (height == null) {
                  return 'Hãy chỉ nhập số';
                }
                if (height! < 50 || height! > 200) {
                  return 'Giới hạn từ 50cm đến 200cm nhé';
                }
                return null;
              },
              inputType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            AppTextFormField(
              controller: _weightController,
              lable: 'Cân nặng (kg)',
              validator: (value) {
                weight = double.tryParse(value ?? '');
                if (weight == null) {
                  return 'Hãy chỉ nhập số';
                }
                if (weight! < 25 || weight! > 100) {
                  return 'Giới hạn từ 25 tới 100kg nhé';
                }
                return null;
              },
              inputType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            AppTextFormField(
              controller: _bmiController,
              lable: 'BMI (kg/m2)',
              validator: (value) {
                bmi = double.tryParse(value ?? '');
                if (bmi == null) {
                  return 'Hãy chỉ nhập số';
                }
                if (bmi! < 16 || bmi! > 30) {
                  return 'Đặt mục tiêu BMI từ 16 tới 30 nhé';
                }
                return null;
              },
              inputType: TextInputType.number,
            ),
            SizedBox(height: 40.h),
            AppButton(
              width: 190.w,
              ontap: () {
                if (!_formKey.currentState!.validate()) return;
                final List<TargetEntity> newTargets = [];
                for (TargetEntity target in targets) {
                  if (target.type == AppConstants.typeHoursSleep) {
                    newTargets.add(target.copyWith(
                        target: double.parse(_hoursController.text)));
                  }
                  if (target.type == AppConstants.typeHeight) {
                    newTargets.add(target.copyWith(
                        target: double.parse(_heightController.text)));
                  }
                  if (target.type == AppConstants.typeWeight) {
                    newTargets.add(target.copyWith(
                        target: double.parse(_weightController.text)));
                  }
                  if (target.type == AppConstants.typeBMI) {
                    newTargets.add(target.copyWith(
                        target: double.parse(_bmiController.text)));
                  }
                  if (target.type == AppConstants.typeStepDaily) {
                    newTargets.add(target.copyWith(
                        target: double.parse(_stepsController.text)));
                  }
                }
                ref
                    .read(allTargetProvider.notifier)
                    .updateAllTarget(newTargets);
                Navigator.pop(context);
              },
              name: 'Chốt luôn',
            ),
          ]),
        ),
      ),
    );
  }
}
