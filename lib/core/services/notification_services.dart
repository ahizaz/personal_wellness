

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((message){
      debugPrint(message.notification!.title.toString());
      debugPrint(message.notification!.body.toString());


    });
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