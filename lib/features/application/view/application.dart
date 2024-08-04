import 'dart:math';
import 'package:nes24_ph55234/common/components/app_drawer_widget.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';
import 'package:nes24_ph55234/common/utils/rive_utils.dart';
import 'package:nes24_ph55234/features/application/controller/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/features/application/view/application_widgets.dart';
import 'package:rive/rive.dart';

class ApplicationScreen extends ConsumerStatefulWidget {
  const ApplicationScreen({super.key});

  @override
  ConsumerState<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends ConsumerState<ApplicationScreen>
    with SingleTickerProviderStateMixin {
  late SMIBool smiBoolDrawerClosed;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeDrawer() {
    ref.read(drawerClosedProvider.notifier).state = true;
    _animationController.reverse();
    smiBoolDrawerClosed.value = true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDrawerClosed = ref.watch(drawerClosedProvider);
    final int selectedIndex = ref.watch(bottomTabsProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(drawerIndexProvider.notifier).state = null;
    });
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            width: 275.w,
            left: isDrawerClosed ? -275.w : 0,
            height: MediaQuery.of(context).size.height,
            child: AppDrawerWidget(
              callBackWhenNavigate: _closeDrawer,
            ),
          ),
          //Dịch chuyển theo offset.(giữ nguyên kích thước)
          GestureDetector(
            onTap: _closeDrawer,
            child: Transform.translate(
              //_animation<double> chạy từ 0 đến 1.
              offset: Offset(_animation.value * 230.w, 0),
              //scale co dãn theo scal, cần thêm background không trùng màu
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(
                      _animation.value - 30 * _animation.value * pi / 180),
                child: Transform.scale(
                  //scaleAnimation<double> 1 - 0.8
                  scale: _scaleAnimation.value,
                  child: ClipRRect(
                          borderRadius: BorderRadius.circular(isDrawerClosed ? 0 : 24),
                          child: screens[selectedIndex]),
                ),
              ),
            ),
          ),
          if (selectedIndex == 0)
            HumbergerButton(
              onTap: () {
                smiBoolDrawerClosed.change(!smiBoolDrawerClosed.value);
                ref.read(drawerClosedProvider.notifier).state = !isDrawerClosed;
                if (isDrawerClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
              onInit: (artboard) {
                StateMachineController? humbergerController =
                    RiveUtils.getRiverController(artboard,
                        stateMachineName: 'State Machine');
                //Khởi tạo SMIbool nhờ vào controller, isOpen ở trong file river
                smiBoolDrawerClosed =
                    humbergerController.findSMI('isOpen') as SMIBool;
                //Ban đầu để nó đóng
                smiBoolDrawerClosed.value = true;
              },
            ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, _animation.value * 80),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 10.h),
            decoration: BoxDecoration(
                color: AppColors.backgroundColor2.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavs.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        bottomNavs[index].input?.change(true);
                        ref.read(bottomTabsProvider.notifier).state = index;

                        Future.delayed(const Duration(seconds: 1), () {
                          bottomNavs[index].input?.change(false);
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBar(isActive: selectedIndex == index),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: RiveAnimation.asset(
                              bottomNavs.first.src,
                              artboard: bottomNavs[index].artboard,
                              onInit: (artboard) {
                                StateMachineController controller =
                                    RiveUtils.getRiverController(
                                  artboard,
                                  stateMachineName:
                                      bottomNavs[index].stateMachineName,
                                );
                                bottomNavs[index].input =
                                    controller.findSMI("active") as SMIBool;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
