import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/provider_global/is_dark_theme_provider.dart';
import 'package:rive/rive.dart';

class AppThemeSwitcher extends ConsumerStatefulWidget {
  final double? height;
  final double? width;
  const AppThemeSwitcher({super.key, this.height = 43.2, this.width = 64.8});
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
          height: widget.height!.h,
          width: widget.width!.w,
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
