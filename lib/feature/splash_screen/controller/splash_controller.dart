import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/get_started.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
   
    super.onInit();
    startDisplay();
    
  }

  void startDisplay()async{
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final accessToken =  prefs.getString("accessToken");
      final userId = prefs.getString("userId");
          if (accessToken != null && userId != null) {
      Get.offAll(() => BottomNavbar());
    } else {
      Get.offAll(() => GetStarted());
    }
  }
}