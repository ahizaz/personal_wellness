import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_wellness/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
if(kIsWeb){
  await  Firebase.initializeApp(options: const FirebaseOptions(

 apiKey: "AIzaSyCYiE-zAmIPkkqhWqY_YPfrG8DFAU6lRVo",
  authDomain: "wellnessapp-4bee1.firebaseapp.com",
  projectId: "wellnessapp-4bee1",
  storageBucket: "wellnessapp-4bee1.firebasestorage.app",
  messagingSenderId: "954043915554",
  appId: "1:954043915554:web:283e2f653c04c7b939d97b",
  measurementId: "G-TEMR64VGJY"
  ));
}else{
await  Firebase.initializeApp();
}
  runApp(const PeronalWellNess());
}

