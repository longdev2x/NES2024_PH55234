import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/data/models/notify_entity.dart';
import 'package:nes24_ph55234/features/notify/controller/notify_provider.dart';
import 'package:nes24_ph55234/global.dart';
import 'package:nes24_ph55234/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize1() async {
    tz.initializeTimeZones();
    await _requestNotificationPermission();
  }

  Future<void> initialize2(BuildContext context, WidgetRef ref) async {
    //Khởi tạo notify plugin phía local, và xử lý onTap to notify
    _setupNotification(context);
    //handle nhận thông báo từ FCM
    _handleFCMReceive(context, ref);
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
        print('zzzzzzz-${details.payload}');
        // Xử lý khi nhấn vào thông báo
        if (details.payload != null) {
          if (details.payload == 'sleep_screen') {
            navKey.currentState!.pushNamed(AppRoutesNames.sleep);
          } else if (details.payload == 'steps_screen') {
            navKey.currentState!.pushNamed(AppRoutesNames.steps);
          } else {
            final String type =
                json.decode(details.payload!)['type'];
            if (type == 'chat') {
              print('zzzzzzz-$type');
              navKey.currentState!.pushNamed(
                  AppRoutesNames.chatScreen);
            }
          }
        }
      },
    );
  }

  //Notification local Sleep
  Future<void> scheduleSleepNotification(
      String channelId,
      String channelName,
      String title,
      String body,
      String payload,
      TimeOfDay sleepTime,
      StateNotifierProviderRef ref) async {
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

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.max,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: channel.importance,
            priority: Priority.high,
            icon: '@drawable/notification_icon',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      //Thêm vào provider thông báo
      // ref.read(notifyProvider.notifier).addNotify(
      //       NotifyEntity(
      //         title: 'Đã đến giờ ngủ',
      //         body: 'Nhấn để bắt đầu theo dõi giấc ngủ của bạn.',
      //         type: 'sleep',
      //         time: DateTime.now(),
      //         isRead: false,
      //       ),
      //     );
      print('zzz22222');
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
  void _handleFCMReceive(BuildContext context, WidgetRef ref) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AndroidNotificationDetails androidDetails;
      print('zzz-Ok getmessage cate- ${message.category}');
      print('zzz-Ok getmessage DATA - ${message.data.toString()}');
      print('zzz-Ok getmessage NOTI - ${message.notification}');

      String? type = message.data['type'];
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      switch (type) {
        case 'chat':
                print('zzzOk come heareChat');
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
            icon: '@mipmap/notification_icon',
          );
          title = title ?? "Thông báo mới";
          body = body ?? "Bạn có một thông báo mới";
      }

      print('zzz-Ok ccc');
      try {
        await _flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          NotificationDetails(android: androidDetails),
          //Trong data có sẵn senderId và type.(lúc gửi cần thêm)
          payload: json.encode(message.data),
        );

        print('zzzok ddax show notify');
        // Thêm vào provider thông báo
        ref.read(notifyProvider.notifier).addNotify(
              NotifyEntity(
                title: title,
                body: body,
                type: type ?? '',
                time: DateTime.now(),
                isRead: false,
              ),
            );
      } catch (e) {
        if (kDebugMode) {
          print('zzzError showing notification: $e');
        }
      }
    });
  }

  Future<String> _getAccessToken() async {
    final jsonKey = {
      "type": "service_account",
      "project_id": "nes24-ph55234",
      "private_key_id": "019291fb51f403294197e0d96f8ce8dcbc8396bb",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCN6DtZI/eSJYdQ\n0yxyoaWJbwG3DJ6IioO+XBbIbAgmLZhUDTCYNfFIBGIEEl0lky3l2aU2IXnPlA5P\nFt15KHPtKwf2s8OzIzapHDULq1eogn7WT/wqp2pv2j7flwMd0jYpaLAgTpnqRck7\n95Z4qppFZyKFyvtR3lBkhuPvm+M4TL+SUXb8XtqH8n0hZOCdWdvJcaspMt6Yzesx\n3U0hc0k12nPsnAfIjf87W3P3kiEPt1wmkyLoBltWLP6lCCHn2AvMiyuh6JshI08f\nDON5GNFpJiAHxq2cwerXLFoYLGM0s0vGOTBD2uM/T2QLgVOqhiFDWaquJCLCcJ8f\nVCI9V54/AgMBAAECggEAPaxQ4sBdb9BMm2Vzu0wid/TdH3NmEPx2HkzCgA9niUQm\noFztIjHLb5usB439mn95IpxxD3IEESGNCHVtAqOAonIhr2fYJSooLt359dzdJ3iz\nbCvt8ZG6EeudiKoGajb6YAvGA/x1KxpyR1QmusGWc5RLri8WA7IlaVMwi+nJmiUn\nLKyuKNaqNX9VkmhrMaK2JUninGNSfkCL2bkMNmbuGskWOy4rOGVSLckmlxjuCB5q\nckydNlVUYdXvFALXD3/cBFIzz8TNp3u/Yh+qM2h03suOBKYzPMHBjU62rCl9Tma8\nU0nnVAFhGqg8pE3BHCKYRAdS+cAD9H1Jdnqd1oU9yQKBgQDAkI8CHx6gersKVrc1\nTi8hkWvua76O7ASIcnUJYgkuUXk6Dzu29/CysnBIvdqsANuTSsXORrxeGrDGisM+\nQCDnEQX+Ee9K4aqo+EQDmmjgky5aKNlFcBLB6tWwxEez9JPvDUqf9Pj+/hlyJKLT\nRrltBC0C8uLh59c17sc7SIwI9wKBgQC8p5o+7Dn3WbQxH5Z/TJRHmF5lQxsraGWV\nE/L3uAi4ZBVuJ4X/qEtFAIAsMH6qY0PcOvGY0oCW1dr4ndX30Q1EIDlZiCYYxF9z\n0xH60dVCxb2ho3FnxT3ePvws2GpAK0iUOjek1T8KwR/gc4lQdBanTra97lxQdPzv\nZ5ndTnDK+QKBgHpoaj/zAEkLO3KrBPNBq/wusOlyXEQGDCugdn1scGGdMO6TWGZK\n3hr6Cx5ycVr9gJb05SDnHj7DwLO06b/cjA3WaHTFedOj+BRJHRMdSKXZaZGufc8C\nGyph2UzwuJPQWWmQjWt5Ef8mD47bcxXS03RVPzespkTsV4XVL5ij2UCpAoGANith\n7ONjmZSWWuyZCCBzC0PDBwyHxqUJVg8OWvbq+hcy2BhdL5WhV0TXiNi75izulVQP\nfzQiXC033N9lSu0qA//Et+KSHdZ1GgrnRL/vnmatFraZn5RROXmYa0AQ8i/7fSRi\nSeA5Y9skTgyexw0uXAgMDOledHPDFPMIiTU2yfECgYBwkxkotRJMR8JDLyJ6FM4T\nwJTwTyN12w5YuNaA3oTec6N0eLprEfFEgmjS3IK/znIfc9i98G3wskVHRqyIOt8T\nHdrdRAX/AfYvO7lAzgUJf/npxQZ391QJRhIbjuyJjzkejiVH2a8DkLyH3fJedBw3\nOA+PCGD3f3+HNvo/A3m6Zw==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "nes24-becom-better@nes24-ph55234.iam.gserviceaccount.com",
      "client_id": "112928093976679315610",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/nes24-becom-better%40nes24-ph55234.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(jsonKey), scopes);

    //get accessToken
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(jsonKey), scopes, client);

    client.close();

    return credentials.accessToken.data;
  }

  //Setup send notification by FCM
  Future<void> sendNotification({
    required String type,
    required String receiverToken,
    required String title,
    required String body,
  }) async {
    //get AccessToken
    final String serverAccessTokenKey = await _getAccessToken();
    // Tạo URL cho API HTTP v1
    var projectId = 'nes24-ph55234'; //project id trên firebaes
    var url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
    print('zzz-Đã tạo url - $url');
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
    print('zzz-Đã tạo payload - ${jsonEncode(payload)}');

    // Gửi yêu cầu POST đến API HTTP v1
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(payload),
    );
    print('zzz-Response status: ${response.statusCode}');
    print('zzz-Response body: ${response.body}');
    print('zzz-$response');
    print('zzz-Đã gửi Post - $url');

    // Xử lý kết quả
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('zzzThành công send notification');
      }
    } else {
      if (kDebugMode) {
        print('zzzGửi notifi thất bại: ${response.body}');
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
