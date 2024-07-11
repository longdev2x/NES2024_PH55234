import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/provider_global/is_dart_theme_provider.dart';
import 'package:rive/rive.dart';

class AppThemeSwitcher extends ConsumerStatefulWidget {
  const AppThemeSwitcher({super.key});
  @override
  ConsumerState<AppThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends ConsumerState<AppThemeSwitcher> {
  SMIInput<bool>? _isDarkInput;

  void _onInit(Artboard artboard) {
    var controller = StateMachineController.fromArtboard(artboard, 'Switch Theme');
    if (controller == null) return;
    artboard.addController(controller);
    _isDarkInput = controller.findInput('isDark');
    if (_isDarkInput != null) {
      _isDarkInput!.change(ref.read(isDarkThemeProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ref.watch(isDarkThemeProvider);

    WidgetsBinding.instance.addPostFrameCallback((ctx) {
      if (_isDarkInput != null) {
        _isDarkInput!.change(isDark);
      }
    });

    return Center(
      child: InkWell(
        onTap: () {
          ref.read(isDarkThemeProvider.notifier).switchThemeMode();
        },
        child: SizedBox(
          height: 43.2.h,
          width: 64.8.w,
          child: RiveAnimation.asset(
            'assets/rives/switch_theme.riv',
            fit: BoxFit.fill,
            stateMachines: const ['Switch Theme'],
            onInit: _onInit,
          ),
        ),
      ),
    );
  }
}
