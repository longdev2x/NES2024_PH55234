import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/services/notification_sevices.dart';
import 'package:nes24_ph55234/data/local/shared_preferences_helper.dart';
import 'package:nes24_ph55234/firebase_options.dart';

class Global {
  static late final SharedPreferencesHelper storageService;
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    NotificationServices().initialize();
    storageService = await SharedPreferencesHelper().init();
  }
}