import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  
  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((message){
   debugPrint(message.notification!.title.toString());
   debugPrint(message.notification!.body.toString());
   showNotification(message);


    });
  }
  Future<void>showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
   channel.id.toString(),
   channel.name.toString(),
   channelDescription: 'your channel description',
   importance: Importance.high,
   priority: Priority.high,
   ticker: 'ticker'

    );
    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(0, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails);
    });

  }
  void initLocalNotifications(BuildContext context)async{
var androidInitializationSettings = const AndroidInitializationSettings('@drawable/notification_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android:androidInitializationSettings,
      iOS: iosInitializationSettings

    );
    await _flutterLocalNotificationsPlugin.initialize(
      
      initializationSettings,
      onDidReceiveNotificationResponse:(payload){

      }
      
      );

  }
  void requestNotificationPermission()async{

    NotificationSettings settings =await messaging.requestPermission(
   alert: true,
   announcement: true,
   badge: true,
   carPlay: true,
   criticalAlert: true,
   provisional: true,
   sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
     debugPrint('user granted permission');
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
     debugPrint('user granted provisional permission');
    }else{
    AppSettings.openAppSettings();
      debugPrint('Please enable notifications from your device settings.');
    }
  }


  Future<String>getDeviceToken()async{
    String?token =  await messaging.getToken();
    return token!;
  }
  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event){
      event.toString();
    });
  }

}