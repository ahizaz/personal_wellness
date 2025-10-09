

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
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
     print('user granted permission');
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
     print('user granted provisional permission');
    }else{
    AppSettings.openAppSettings();
      print('Please enable notifications from your device settings.');
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