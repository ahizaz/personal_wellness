import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAccountController extends GetxController {
  var selectedMonth = ''.obs;
  // First Name Controller এবং স্টেট
  final TextEditingController firstNameController = TextEditingController();
  final RxBool isFirstNameFocused = false.obs;
  final RxBool hasFirstNameText = false.obs;

  // Last Name Controller এবং স্টেট
  final TextEditingController lastNameController = TextEditingController();
  final RxBool isLastNameFocused = false.obs;
  final RxBool hasLastNameText = false.obs;

  // Age Controller এবং স্টেট
  final TextEditingController ageController = TextEditingController();
  final RxBool isAgeFocused = false.obs;
  final RxBool hasAgeText = false.obs;

  // Gender স্টেট
  final RxString selectedGender = ''.obs;

  // ফর্ম ভ্যালিডেশন (সব ফিল্ডেই টেক্সট থাকতে হবে)
  RxBool get isFormValid => (hasFirstNameText.value && hasLastNameText.value && hasAgeText.value && selectedGender.value.isNotEmpty).obs;

  @override
  void onInit() {
    super.onInit();

    // প্রথম নামের টেক্সট লিসেনার
    firstNameController.addListener(() {
      hasFirstNameText.value = firstNameController.text.isNotEmpty;
    });

    // শেষ নামের টেক্সট লিসেনার
    lastNameController.addListener(() {
      hasLastNameText.value = lastNameController.text.isNotEmpty;
    });

    // Age এর টেক্সট লিসেনার
    ageController.addListener(() {
      hasAgeText.value = ageController.text.isNotEmpty;
    });
  }

  Future<void> updateProfile() async {
    EasyLoading.show(status: 'Updating profile...');
    debugPrint('=== Starting profile update ===');

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String age = ageController.text.trim();
    final String gender = selectedGender.value.toLowerCase();
    
    debugPrint('First Name to update: $firstName');
    debugPrint('Last Name to update: $lastName');
    debugPrint('Age to update: $age');
    debugPrint('Gender to update: $gender');

    try {
      final String? token = await ApiService.getAccessToken();
      debugPrint('Retrieved token: ${token != null ? 'Present' : 'Null'}');
      
      if (token == null || token.isEmpty) {
        debugPrint('No token found - user not authenticated');
        EasyLoading.showError('Please login first');
        return;
      }

      final url = Uri.parse(Urls.updateProfile);
      debugPrint('Request URL: ${url.toString()}');

      final request = http.MultipartRequest('PATCH', url);
      request.headers['Authorization'] = 'Bearer $token';
      debugPrint('Request headers: ${request.headers}');

      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['age'] = age;
      request.fields['gender'] = gender;
      debugPrint('Request fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Parsed response data: $data');

        if (data['success'] == true) {
          final userData = data['data'];
          final newFirstName = userData['firstName'] ?? firstName;
          
          debugPrint('New first name from response: $newFirstName');
          
          // Save to SharedPreferences and update Firebase displayName
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('personalization_firstName', newFirstName);
          // Also set a quick local fallback
          await prefs.setString('user_name', newFirstName);
          debugPrint('Saved new first name to prefs');

          // Update TodayController
          final todayController = Get.find<TodayController>();
          todayController.setUserName(newFirstName);
          debugPrint('Updated TodayController userName');

          // Try to update FirebaseAuth displayName so future installs/readers get the name
          try {
            final firebaseUser = FirebaseAuth.instance.currentUser;
            if (firebaseUser != null) {
              await firebaseUser.updateDisplayName(newFirstName);
              debugPrint('Updated FirebaseAuth displayName: $newFirstName');
            }
          } catch (e) {
            debugPrint('Error updating Firebase displayName: $e');
          }

          // Refresh personalization in TodayController
          await todayController.refreshPersonalizationData();
          debugPrint('Refreshed personalization data');

          EasyLoading.showSuccess(data['message'] ?? 'Profile updated successfully');
          
          // Clear fields and close
          clearAllData();
          Get.back();
        } else {
          debugPrint('Success false in response');
          EasyLoading.showError(data['message'] ?? 'Update failed');
        }
      } else {
        debugPrint('Non-200 status code');
        EasyLoading.showError('Failed to update profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error during update: $e');
      EasyLoading.showError('An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
      debugPrint('=== Profile update completed ===');
    }
  }

  // সব ডাটা ক্লিয়ার করার মেথড
  void clearAllData() {
    clearFirstName();
    clearLastName();
    clearAge();
    clearGender();
  }

  void clearFirstName() {
    firstNameController.clear();
    hasFirstNameText.value = false;
  }

  void clearLastName() {
    lastNameController.clear();
    hasLastNameText.value = false;
  }

  void clearAge() {
    ageController.clear();
    hasAgeText.value = false;
  }

  void clearGender() {
    selectedGender.value = '';
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.onClose();
  }
}