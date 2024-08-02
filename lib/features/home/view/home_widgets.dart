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
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/home/controller/all_target_provider.dart';
import 'package:nes24_ph55234/features/home/controller/banner_dots_provider.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/sleep/controller/sleep_provider.dart';
import 'package:nes24_ph55234/features/step/controller/daily_step_provider.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:nes24_ph55234/main.dart';

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
      Row(
        children: [
          fetchUser.when(
            data: (objUser) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutesNames.profile);
              },
              child: Hero(
                tag: objUser.avatar ?? '',
                child: CircleAvatar(
                  backgroundImage: objUser.avatar != null
                      ? NetworkImage(objUser.avatar!)
                      : const AssetImage(ImageRes.avatarDefault)
                          as ImageProvider,
                ),
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

  List<BannerContainer> getList(WidgetRef ref) {
    UserEntity? objUser = ref.watch(profileProvider).value;
    return [
      BannerContainer(
          onTap: () => navKey.currentState!.pushNamed(AppRoutesNames.steps),
          text: 'Thể chất',
          imagePath: ImageRes.stepCounterBanner),
      BannerContainer(
          onTap: () => navKey.currentState!.pushNamed(AppRoutesNames.sleep),
          text: 'Giấc ngủ',
          imagePath: ImageRes.sleepBanner),
      BannerContainer(
          onTap: () => navKey.currentState!.pushNamed(AppRoutesNames.grateful),
          text: 'Tinh thần',
          imagePath: ImageRes.gratefulBanner),
      BannerContainer(
          onTap: () => navKey.currentState!.pushNamed(AppRoutesNames.bmi),
          text: 'Ăn uống',
          imagePath: ImageRes.bmiBanner),
      BannerContainer(
          onTap: () => navKey.currentState!.pushNamed(AppRoutesNames.yoga),
          text: 'Sức khoẻ tinh thần',
          imagePath: ImageRes.yogaBanner),
      BannerContainer(
          onTap: () {
            if (objUser != null) {
              if (objUser.role == listRoles[0]) {
                navKey.currentState!.pushNamed(AppRoutesNames.adviseUser);
              } else {
                navKey.currentState!.pushNamed(AppRoutesNames.adviseExpext);
              }
            }
          },
          text: 'Tư vấn bí mật',
          imagePath: ImageRes.adviseBanner),
    ];
  }

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
      if (_currentIndex < getList(ref).length - 1) {
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
            children: getList(ref),
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
          dotsCount: getList(ref).length,
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
  final Function() onTap;
  final String imagePath;
  final String text;
  const BannerContainer(
      {super.key,
      required this.onTap,
      required this.imagePath,
      required this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 325.h,
        width: 160.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}

class HomeAnalysisWidget extends ConsumerWidget {
  final List<TargetEntity> targets;
  const HomeAnalysisWidget({super.key, required this.targets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchStep = ref.watch(dailyStepProvider);
    final fetchProfile = ref.watch(profileProvider);
    final List<SleepEntity> listSleeps = ref.watch(sleepProvider);

    return fetchProfile.when(
      data: (profile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutesNames.bmi),
                  child: _buildHealthCard(profile)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(AppRoutesNames.sleep),
                      child: _buildSleepCard(
                          listSleeps, _getTarget(AppConstants.typeHoursSleep)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(AppRoutesNames.steps),
                      child: _buildStepCard(
                          fetchStep, _getTarget(AppConstants.typeStepDaily)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      error: (e, s) => const Center(child: Text('Profile Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppText20('Thành tích', fontWeight: FontWeight.bold),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => HomeSetTargetWidget(targets: targets),
            );
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
            ),
          ),
          child: const AppText16(
            'Đặt lại mục tiêu',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(
      AsyncValue<List<StepEntity>> fetchStep, TargetEntity? target) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
        child: SizedBox(
          height: 105.w,
          width: 135.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_walk,
                      size: 30, color: Colors.blue),
                  SizedBox(width: 10.w),
                  const AppText19('Bước chân', fontWeight: FontWeight.bold),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fetchStep.when(
                    data: (steps) {
                      StepEntity todayStep = steps.last;
                      return AppProgresTarget(
                        name: todayStep.step.toString(),
                        percent: (todayStep.step / (target?.target ?? 10000))
                            .clamp(0.0, 1.0),
                        radius: 30,
                      );
                    },
                    error: (e, s) => Text('Lỗi: $e'),
                    loading: () => const CircularProgressIndicator(),
                  ),
                  SizedBox(width: 6.h),
                  Column(
                    children: [
                      const AppText14('Mục tiêu'),
                      AppText14(
                        '${target?.target.toInt() ?? 2500} bước',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepCard(List<SleepEntity> listSleeps, TargetEntity? target) {
    double sleepHours = 0;
    if (listSleeps.isNotEmpty && listSleeps.first.endTime != null) {
      sleepHours = listSleeps.first.endTime!
          .difference(listSleeps.first.startTime!)
          .inHours
          .toDouble();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
        child: SizedBox(
          height: 105.w,
          width: 135.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bedtime, size: 30, color: Colors.indigo),
                  SizedBox(width: 10.w),
                  const AppText19('Giấc ngủ', fontWeight: FontWeight.bold),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppProgresTarget(
                    name: '${sleepHours.toStringAsFixed(1)} h',
                    percent:
                        (sleepHours / (target?.target ?? 8)).clamp(0.0, 1.0),
                    radius: 30,
                  ),
                  SizedBox(width: 5.h),
                  Column(
                    children: [
                      const AppText14('Mục tiêu'),
                      AppText14(
                        '${target?.target ?? 8} giờ',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(UserEntity profile) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
        child: Column(
          children: [
            Column(
              children: [
                const AppText19('Chỉ số sức khoẻ', fontWeight: FontWeight.bold),
                SizedBox(height: 12.h),
                _buildBMIIndicator(profile),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHealthInfo(Icons.height, 'Chiều cao',
                    '${profile.height?.toInt() ?? 0} cm'),
                SizedBox(width: 25.w),
                _buildHealthInfo(Icons.monitor_weight, 'Cân nặng',
                    '${profile.weight?.toInt() ?? 0} kg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIIndicator(UserEntity objUser) {
    double bmi = objUser.calculateBMI();
    Color bmiColor = _getBMIColor(bmi);
    String bmiCategory = _getBMICategory(bmi);

    return Column(
      children: [
        SizedBox(
          height: 130,
          width: 130,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: (bmi / 30).clamp(0.0, 1.0),
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(bmiColor),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText16('BMI', fontWeight: FontWeight.bold),
                    AppText20(bmi.toStringAsFixed(1),
                        fontWeight: FontWeight.bold, color: bmiColor),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        AppText16(bmiCategory, color: bmiColor, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _buildHealthInfo(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        SizedBox(height: 2.h),
        // AppText14(label),
        AppText16(value, fontWeight: FontWeight.bold),
      ],
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Thiếu cân';
    if (bmi < 25) return 'Bình thường';
    if (bmi < 30) return 'Thừa cân';
    return 'Béo phì';
  }

  TargetEntity? _getTarget(String type) {
    return targets.firstWhere((t) => t.type == type,
        orElse: () => TargetEntity(
            userId: Global.storageService.getUserId(), type: type, target: 0));
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
