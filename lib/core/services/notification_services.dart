import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 🔹 Call this in initState or at app start
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('⚠️ User granted provisional permission');
    } else {
      AppSettings.openAppSettings();
      debugPrint('🚫 Please enable notifications from device settings.');
    }
  }

  // Check if notifications are enabled from device settings
  Future<bool> areNotificationsEnabled() async {
    final NotificationSettings settings = await messaging
        .getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('🔔 Foreground Message: ${message.notification?.title}');

      // Check if notifications are enabled before showing
      final bool notificationsEnabled = await areNotificationsEnabled();
      if (notificationsEnabled) {
        showNotification(message);
      } else {
        debugPrint(
          '🔕 Notifications disabled from device settings - not showing notification',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
        '📲 Notification tapped (app opened): ${message.notification?.title}',
      );
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    // Double-check permission before showing notification
    final bool notificationsEnabled = await areNotificationsEnabled();
    if (!notificationsEnabled) {
      debugPrint('🔕 Notifications disabled - skipping notification display');
      return;
    }
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = message.data['title'] ?? message.notification?.title;
    final body = message.data['body'] ?? message.notification?.body;

    if (title != null && body != null) {
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
      );
    }
  }

  void initLocalNotifications(BuildContext context) async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/notification_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint(
          '🔹 Notification tapped (foreground/local): ${response.payload}',
        );
      },
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    debugPrint('📱 FCM Token: $token');
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      debugPrint('🔄 Token refreshed: $event');
    });
  }
}
