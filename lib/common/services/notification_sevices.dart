import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    //request Permission from User
    requestNotificationPermission();
    //Fetch the FCM token for this device
    final fCMtoken = await getDeviceToken();
    //print the token
    print('Token: $fCMtoken');
  }

  // hàm yêu cầu cấp quyền
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("user granted permission");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User denied permission');
      }
    }
  }

  Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  //Khởi tạo cài đặt cho thông báo cục bộ .
  //Cấu hình biểu tượng cho Android và các cài đặt cho iOS.
  void initLocalNotifications(
      {required BuildContext context, required RemoteMessage msg}) async {
    var androidInitlization =
        const AndroidInitializationSettings('@mipmap/ic_launcher.png');

    var iosInitlization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitlization,
      iOS: iosInitlization,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );
  }

  //Lắng nghe các thông báo đến khi ứng dụng đang chạy (foreground).
  //Khi nhận được thông báo, nó gọi initLocalNotifications() và showNotification().
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(context: context, msg: message);
        _handelMessage(message);
      }
      // AppDialog.showToast(message.notification?.title.toString());
    });
  }

  Future<void> _handelMessage(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: 'Your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
        );
      },
    );
  }

  void isTokenRefersh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('Refresh');
      }
    });
  }
}
