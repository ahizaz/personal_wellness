import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:personal_wellness/app.dart';
import 'package:personal_wellness/firebase_options.dart';
import 'package:personal_wellness/core/services/server_key.dart';
final GlobalKey<NavigatorState>nevegator = GlobalKey();
Future bg_notification(RemoteMessage message)async{
  if(message.notification!=null){
    if(message.notification!=null){
      debugPrint('message received in BG');
    }
  }
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options:DefaultFirebaseOptions.currentPlatform,
  );

  // Print server key to console
  try {
    await GetServerKey().printServerKeyToConsole();
  } catch (e) {
    debugPrint('Error printing server key: $e');
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const PeronalWellNess());
}
@pragma('vm:entry-point')
Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  debugPrint(message.notification!.title.toString());
}