import 'dart:io';
import 'package:flutter/foundation.dart';
// device_preview removed

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:personal_wellness/app.dart';
import 'package:personal_wellness/firebase_options.dart';
import 'package:personal_wellness/core/services/server_key.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> nevegator = GlobalKey();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Check if notifications are enabled from device settings
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final NotificationSettings settings = await messaging
      .getNotificationSettings();
  final bool notificationsEnabled =
      settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;

  if (!notificationsEnabled) {
    debugPrint(
      '🔕 Background: Notifications disabled from device settings - not showing notification',
    );
    return;
  }

  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@drawable/notification_icon');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'bg_channel',
      'Background Notifications',
      channelDescription:
          'Notifications when app is terminated or in background',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  // Handle both data-only and notification messages
  final title = message.data['title'] ?? message.notification?.title;
  final body = message.data['body'] ?? message.notification?.body;

  if (title != null && body != null) {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  debugPrint('🔔 Background handler triggered: $title');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Print server key to console
  try {
    await GetServerKey().printServerKeyToConsole();
  } catch (e) {
    debugPrint('Error printing server key: $e');
  }

  // Initialize local notifications (for foreground use)
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@drawable/notification_icon');
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Background message handler registration
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request App Tracking Transparency on iOS before any tracking (Guideline 5.1.2)
  if (Platform.isIOS) {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 500));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint('ATT request error: $e');
    }
  }

  runApp(const PeronalWellNess());
}
