import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsDarkNotifier extends StateNotifier<bool> with WidgetsBindingObserver{ 
  IsDarkNotifier() : super(false) {
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void switchThemeMode() {
    state = !state;
  }

  void _initialize() {
    state = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  @override
  void didChangePlatformBrightness() {
    state = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    super.didChangePlatformBrightness();
  }
}

final isDarkThemeProvider = StateNotifierProvider<IsDarkNotifier, bool>((ref) => IsDarkNotifier());