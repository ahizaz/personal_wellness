import 'dart:io';
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
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted permission');

      // For iOS, get APNS token after permission is granted
      if (Platform.isIOS) {
        await _setupAPNSToken();
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('⚠️ User granted provisional permission');

      // For iOS, get APNS token after permission is granted
      if (Platform.isIOS) {
        await _setupAPNSToken();
      }
    } else {
      AppSettings.openAppSettings();
      debugPrint('🚫 Please enable notifications from device settings.');
    }
  }

  // Helper method to setup APNS token for iOS
  Future<void> _setupAPNSToken() async {
    if (!Platform.isIOS) return;

    try {
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) {
        debugPrint('📱 APNS Token received: ${apnsToken.substring(0, 20)}...');
        return;
      }

      debugPrint('⚠️ APNS Token not available yet, waiting...');

      // Retry mechanism with exponential backoff
      for (int i = 0; i < 5; i++) {
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          debugPrint(
            '📱 APNS Token received on retry $i: ${apnsToken.substring(0, 20)}...',
          );
          return;
        }
      }

      debugPrint('⚠️ APNS Token still not available after retries');
    } catch (e) {
      debugPrint('❌ Error getting APNS token: $e');
    }
  }

  // Check if notifications are enabled from device settings
  Future<bool> areNotificationsEnabled() async {
    final NotificationSettings settings = await messaging
        .getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> firebaseInit() async {
    // For iOS, ensure APNS token is set up first
    if (Platform.isIOS) {
      await _setupAPNSToken();
    }

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
    try {
      // For iOS, ensure APNS token is available first
      if (Platform.isIOS) {
        await _setupAPNSToken();

        // Wait a bit more for APNS token to be processed
        await Future.delayed(const Duration(milliseconds: 500));
      }

      String? token = await messaging.getToken();
      if (token != null) {
        debugPrint('📱 FCM Token: $token');
        return token;
      } else {
        throw Exception('FCM token is null');
      }
    } catch (e) {
      debugPrint('❌ Error getting device token: $e');
      rethrow;
    }
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      debugPrint('🔄 Token refreshed: $event');
    });
  }
}
