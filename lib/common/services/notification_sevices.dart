import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:nes24_ph55234/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AuthClient _httpClient;

  Future<void> initialize1() async {
    tz.initializeTimeZones();
    await _requestNotificationPermission();
    await getDeviceToken();
    await _initializeHttpClient();
  }

  Future<void> initialize2(BuildContext context) async {
    //Khởi tạo notify plugin phía local, và xử lý onTap to notify
    _setupNotification(context);
    //handle nhận thông báo từ FCM
    _handleFCMReceive(context);
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

  void _setupNotification(BuildContext context) async {
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Xử lý khi nhấn vào thông báo
        if (details.payload != null) {
          if (details.payload == 'sleep_screen') {
            navKey.currentState!.pushNamed(AppRoutesNames.sleep);
          } else {
            final String type =
                json.decode(details.payload!)['message']['type'];
            if (type == 'chat') {
              final String senderId =
                  json.decode(details.payload!)['message']['sender_id'];
              navKey.currentState!.pushReplacementNamed(
                  AppRoutesNames.messageScreen,
                  arguments: senderId);
            }
          }
        }
      },
    );
  }

  //Notification local Sleep
  Future<void> scheduleSleepNotification(TimeOfDay sleepTime) async {
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
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'sleep_screen',
      );
      if (kDebugMode) {
        print("zzzĐã lên lịch thông báo thành công");
      }
    } catch (e) {
      if (kDebugMode) {
        print("zzzLỗi khi lên lịch thông báo: $e");
      }
    }
  }

//setup for message come from FCM
  void _handleFCMReceive(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AndroidNotificationDetails androidDetails;

      String? type = message.data['type'];
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      switch (type) {
        case 'chat':
          androidDetails = const AndroidNotificationDetails(
            'chat_channel',
            'Chat Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/chat_icon',
          );
          title = title ?? "Tin nhắn mới";
          body = body ?? "";
          break;
        case 'friend_request':
          androidDetails = const AndroidNotificationDetails(
            'friend_channel',
            'Friend Request Notifications',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@drawable/friend_icon',
          );
          title = title ?? "Lời mời kết bạn mới";
          body = body ?? "Bạn có một lời mời kết bạn mới";
          break;
        case 'expert_advice':
          androidDetails = const AndroidNotificationDetails(
            'expert_channel',
            'Expert Advice Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/expert_icon',
          );
          title = "Tư vấn từ chuyên gia";
          body = body ?? "Bạn có một thông báo tư vấn mới";
          break;
        case 'user_need_advice':
          androidDetails = const AndroidNotificationDetails(
            'user_need_channel',
            'User Need Advice Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/expert_icon',
          );
          title = title ?? "Tư vấn từ chuyên gia";
          body = body ?? "Bạn có một thông báo tư vấn mới";
          break;
        default:
          androidDetails = const AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          );
          title = title ?? "Thông báo mới";
          body = body ?? "Bạn có một thông báo mới";
      }

      try {
        await _flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          NotificationDetails(android: androidDetails),
          //Trong data có sẵn senderId và type.(lúc gửi cần thêm)
          payload: json.encode(message.data),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error showing notification: $e');
        }
      }
    });
  }

  Future<void> _initializeHttpClient() async {
    final jsonKey =
        File('/path/to/your/service-account.json').readAsStringSync();
    var credentials = ServiceAccountCredentials.fromJson(jsonKey);
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    _httpClient = await clientViaServiceAccount(credentials, scopes);
  }

  //Setup send notification by FCM
  Future<void> sendNotification({
    required String type,
    required String receiverToken,
    required String title,
    required String body,
  }) async {
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
        'data': {
          'type': type,
          'senderId': Global.storageService.getUserId(),
        }
      },
    };

    // Gửi yêu cầu POST đến API HTTP v1
    var response = await _httpClient.post(
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

  //Get token
  Future<String?> getDeviceToken() async {
    final String? token = await messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }
    return token;
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
}
