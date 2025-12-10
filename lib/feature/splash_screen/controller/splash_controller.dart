import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/get_started.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/question_answer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/services/api_service.dart';

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
    
    debugPrint('=== Splash Screen - Checking authentication ===');
    debugPrint('Access Token exists: ${accessToken != null}');
    debugPrint('User ID exists: ${userId != null}');
    
    if (accessToken != null && userId != null) {
      // Try to fetch the server-side profile and cache the first name so
      // it will be available even after an uninstall/reinstall.
      try {
        await ApiService.fetchAndCacheUserProfile();
      } catch (e) {
        debugPrint('Error fetching profile during splash: $e');
      }

      // Check if questions have been answered
      final hasAnsweredQuestions = prefs.getBool('hasAnsweredQuestions') ?? false;
      debugPrint('hasAnsweredQuestions: $hasAnsweredQuestions');
      
      if (hasAnsweredQuestions) {
        debugPrint('Questions already answered, navigating to BottomNavbar');
        Get.offAll(() => BottomNavbar());
      } else {
        debugPrint('Questions not answered yet, navigating to QuestionAnswer');
        Get.offAll(() => const QuestionAnswer());
      }
    } else {
      debugPrint('User not logged in, navigating to GetStarted');
      Get.offAll(() => GetStarted());
    }
  }
}