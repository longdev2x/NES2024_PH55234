import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/routes/routes.dart';
import 'package:nes24_ph55234/common/utils/app_theme_datas.dart';
import 'package:nes24_ph55234/common/provider_global/is_dark_theme_provider.dart';
import 'package:nes24_ph55234/global.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  await Global.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkThemeProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        title: 'NES24 PH55234 Hoàng Nhật Long',
        theme: AppThemeDatas.lightTheme,
        darkTheme: AppThemeDatas.darkTheme,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        onGenerateRoute: (settings) {
          return AppRoutes.generateRoutSettings(settings);
        },
      ),
    );
  }
}
