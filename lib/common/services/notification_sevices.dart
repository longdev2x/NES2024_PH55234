import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/data/models/friend_entity.dart';
import 'package:nes24_ph55234/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize1() async {
    tz.initializeTimeZones();
    await _requestNotificationPermission();
    await getDeviceToken();
  }

  Future<void> initialize2(BuildContext context) async {
    _initLocalNotifications(context);
    _setupNotificationTapAction(context);
    //Luồng stream khi ở foreground
    _setupForegroundNotificationHandler(context);
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    if (kDebugMode) {
      print('Người dùng đã : ${settings.authorizationStatus}');
    }
  }

  Future<String?> getDeviceToken() async {
    final String? token = await messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }
    return token;
  }

  //Bỏ qua IOS do k có tài khoản devoloper
  void _initLocalNotifications(BuildContext context) async {
    //cài đặt khởi tạo cho Android
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher.png');

    //cài đặt khởi tạo plugin thông báo cục bộ(hiện chỉ khai báo android)
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );
    //khởi tạo plugin thông báo cục bộ
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //Callback khi user tap notification
      onDidReceiveNotificationResponse: (details) {
        //handler ontap to notification....
      },
    );
  }

//Luồng stream khi ở foreground,
  void _setupForegroundNotificationHandler(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message, context);
    });
  }

  Future<void> _handleMessage(
      RemoteMessage message, BuildContext context) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'message_channel', //iid channel cho kênh nhắn tin
      'Message Notifications',
      importance: Importance.max,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? "Tin nhắn mới",
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: json.encode(
            message.data), // Thêm payload để xử lý khi nhấn vào thông báo
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error notification: $e');
      }
    }
  }

  void _setupNotificationTapAction(BuildContext context) {
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print("zzzĐã nhận phản hồi từ thông báo: ${details.payload}");
        // Xử lý khi nhấn vào thông báo
        if (details.payload != null) {
          if (details.payload == 'sleep_screen') {
            print("zzzChuyển đến màn hình Sleep");
            Navigator.pushNamed(context, AppRoutesNames.sleep);
          } else {
            final data = json.decode(details.payload!);
            Navigator.pushNamed(
              context,
              AppRoutesNames.messageScreen,
              arguments: FriendEntity(
                friendId: data['senderId'],
                username: data['senderName'],
                avatar: data['senderAvatar'],
              ),
            );
          }
        }
      },
    );
  }

  //Luồng stream khi token dc generate lại, cần cập nhật lại
  void isTokenRefersh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('Refresh');
      }
    });
  }

  //Notification Sleep
  Future<void> scheduleSleepNotification(TimeOfDay sleepTime) async {
    print(
        "zzzĐang lên lịch thông báo giờ ngủ cho ${sleepTime.format(navKey.currentState!.context)}");
    final vietnamTime = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnamTime);

    var scheduledDate = tz.TZDateTime(
      vietnamTime,
      now.year,
      now.month,
      now.day,
      sleepTime.hour,
      sleepTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print("zzzThời gian lên lịch: $scheduledDate");


    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'sleep_channel_id', //iid channel cho kênh nhắn tin
      'Sleep Notifications',
      importance: Importance.max,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Đã đến giờ ngủ!',
        'Nhấn để bắt đầu theo dõi giấc ngủ của bạn.',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: channel.importance,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'sleep_screen',
      );
      print("zzzĐã lên lịch thông báo thành công");
    } catch (e) {
      print("zzzLỗi khi lên lịch thông báo: $e");
    }
  }

  //Setup send notification
  Future<void> sendNotification({
    required String type,
    required String receiverToken,
    required String title,
    required String body,
  }) async {
    // Đường dẫn tới tệp JSON key của tài khoản dịch vụ
    final jsonKey = File(
            '/Users/hoanglong/Desktop/NES24_PH55234/nes24-ph55234-firebase-adminsdk-43wdc-de5ba10c9e.json')
        .readAsStringSync();
    // Tạo Credential từ JSON key
    var credentials = ServiceAccountCredentials.fromJson(jsonKey);
    // Phạm vi cho FCM API
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    // Tạo một HTTP client
    var httpClient = await clientViaServiceAccount(credentials, scopes);
    // Tạo URL cho API HTTP v1
    var projectId = 'nes24-ph55234'; //project id trên firebaes
    var url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');

    // Payload thông báo
    var payload = {
      'message': {
        'token': receiverToken,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };

    // Gửi yêu cầu POST đến API HTTP v1
    var response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    // Xử lý kết quả
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Thành công send notification');
      }
    } else {
      if (kDebugMode) {
        print('Gửi notifi thất bại: ${response.body}');
      }
    }
  }
}
