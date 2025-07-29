import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/get_started.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
   
    super.onInit();
    startDisplay();
    
  }
  void startDisplay(){
    Timer(const Duration(seconds: 5),(){
   Get.off(()=>GetStarted());
    });
  }
}