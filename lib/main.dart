import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/routes/routes.dart';
import 'package:nes24_ph55234/common/provider_global/is_dark_theme_provider.dart';
import 'package:nes24_ph55234/common/services/notification_sevices.dart';
import 'package:nes24_ph55234/common/utils/app_theme_datas.dart';
import 'package:nes24_ph55234/global.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  await Global.init();
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NotificationServices().initialize1();
    NotificationServices().initialize2(context, ref);
    final isDark = ref.watch(isDarkThemeProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        supportedLocales: supportedLocales,
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        onGenerateRoute: (settings) {
          return AppRoutes.generateRoutSettings(settings);
        },
      ),
    );
  }


  //    final localizationsDelegates = const [
  //   GlobalMaterialLocalizations.delegate,
  //   GlobalWidgetsLocalizations.delegate,
  //   GlobalCupertinoLocalizations.delegate,
  // ];
  final supportedLocales = const [
    Locale('vi', 'VN'), // Tiếng Việt
    Locale('en', 'US'), // Tiếng Anh (hoặc các ngôn ngữ khác nếu cần)
  ];
  
}
