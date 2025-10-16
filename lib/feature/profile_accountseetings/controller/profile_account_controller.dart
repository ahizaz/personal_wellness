import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
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

  // ফর্ম ভ্যালিডেশন (দুটি ফিল্ডেই টেক্সট থাকতে হবে)
  RxBool get isFormValid => (hasFirstNameText.value && hasLastNameText.value).obs;

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
  }

  Future<void> updateProfile() async {
    EasyLoading.show(status: 'Updating profile...');
    debugPrint('=== Starting profile update ===');

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    
    debugPrint('First Name to update: $firstName');
    debugPrint('Last Name to update: $lastName');

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
          
          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('personalization_firstName', newFirstName);
          debugPrint('Saved new first name to prefs');

          // Update TodayController
          final todayController = Get.find<TodayController>();
          todayController.setUserName(newFirstName);
          debugPrint('Updated TodayController userName');

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

  // সব ডাটা ক্লিয়ার করার মেথড
  void clearAllData() {
    clearFirstName();
    clearLastName();
  }

  void clearFirstName() {
    firstNameController.clear();
    hasFirstNameText.value = false;
  }

  void clearLastName() {
    lastNameController.clear();
    hasLastNameText.value = false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}