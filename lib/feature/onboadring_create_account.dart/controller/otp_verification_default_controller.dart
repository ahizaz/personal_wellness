// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/sign_in_controller.dart';

// class OtpVerificationDefaultController extends GetxController{
//   final otpController = TextEditingController();
//   final isOtpFocused = false.obs;
//   final isOtpValid = false.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     otpController.addListener((){
//      isOtpValid.value = otpController.text.length==6;
//     });
//   }
//   Future<void>verifyOtp()async{
//     if (!isOtpValid.value) return;
//     final SignInController = Get.find<SignInController>();
//   }
//   void clearOtp(){
//     otpController.clear();
//     isOtpValid.value=false;
//   }
//   @override
//   void onClose() {
// otpController.dispose();
//     super.onClose();
//   }
// } 
// Updated OtpVerificationDefaultController to use EasyLoading instead of Get.snackbar
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/feature/account_personalization.dart/screen/display_name.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/sign_in_controller.dart';

class OtpVerificationDefaultController extends GetxController {
  final otpController = TextEditingController();
  final isOtpFocused = false.obs;
  final isOtpValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    otpController.addListener(() {
      isOtpValid.value = otpController.text.length == 6;
    });
  }

  Future<void> verifyOtp() async {
    if (!isOtpValid.value) return;

    final signInController = Get.find<SignInController>();
    final email = signInController.email.value;
    final otp = otpController.text;

    if (email.isEmpty || otp.isEmpty) {
      EasyLoading.showError('Email or OTP cannot be empty');
      return;
    }

    try {
      // Show loading indicator
      await EasyLoading.show(status: 'Verifying OTP...');

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/auth/verify-email'), // Assuming Urls.baseUrl is defined; adjust if needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'oneTimeCode': int.tryParse(otp) ?? 0, // Parse to int, default to 0 if invalid
        }),
      );

      // Dismiss loading indicator
      await EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('=== OTP VERIFICATION SUCCESS ===');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        debugPrint('===============================');
        
        try {
          // Parse response and extract token
          final responseData = jsonDecode(response.body);
          debugPrint('=== PARSING OTP RESPONSE ===');
          debugPrint('Response Type: ${responseData.runtimeType}');
          debugPrint('Response Keys: ${responseData is Map ? responseData.keys.toList() : 'Not a Map'}');
          debugPrint('===========================');
          
          String? accessToken;
          String? userId;
          
          // Try different possible response structures
          if (responseData is Map<String, dynamic>) {
            // Check for direct token fields
            accessToken = responseData['accessToken'] ?? responseData['access_token'] ?? responseData['token'];
            userId = responseData['userId'] ?? responseData['user_id'] ?? responseData['id'];
            
            // Check for nested data object
            if (accessToken == null && responseData.containsKey('data')) {
              final dataObj = responseData['data'];
              if (dataObj is Map<String, dynamic>) {
                accessToken = dataObj['accessToken'] ?? dataObj['access_token'] ?? dataObj['token'];
                userId = dataObj['userId'] ?? dataObj['user_id'] ?? dataObj['id'];
              }
            }
            
            // Check for nested user object
            if (responseData.containsKey('user')) {
              final userObj = responseData['user'];
              if (userObj is Map<String, dynamic>) {
                if (userId == null) {
                  userId = userObj['userId'] ?? userObj['user_id'] ?? userObj['id'] ?? userObj['_id'];
                }
              }
            }
          }
          
          debugPrint('=== EXTRACTED TOKENS ===');
          debugPrint('Access Token: ${accessToken != null ? "${accessToken.substring(0, accessToken.length < 20 ? accessToken.length : 20)}..." : "NULL"}');
          debugPrint('User ID: $userId');
          debugPrint('=======================');
          
          if (accessToken != null && accessToken.isNotEmpty) {
            // Save tokens to SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('accessToken', accessToken);
            
            if (userId != null && userId.isNotEmpty) {
              await prefs.setString('userId', userId);
            }
            
            debugPrint('=== TOKENS SAVED SUCCESSFULLY ===');
            debugPrint('Access Token Length: ${accessToken.length}');
            debugPrint('User ID: $userId');
            debugPrint('================================');
            
            // Success: Clear OTP and navigate to DisplayName
            clearOtp();
            Get.to(() => DisplayName());
          } else {
            debugPrint('=== TOKEN EXTRACTION FAILED ===');
            debugPrint('No access token found in response');
            debugPrint('==============================');
            EasyLoading.showError('Login successful but no access token received');
          }
        } catch (e) {
          debugPrint('=== TOKEN PARSING ERROR ===');
          debugPrint('Error: $e');
          debugPrint('Response Body: ${response.body}');
          debugPrint('==========================');
          EasyLoading.showError('Login successful but failed to process response');
        }
      } else {
        debugPrint('=== OTP VERIFICATION FAILED ===');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        debugPrint('==============================');
        // Handle error response
        EasyLoading.showError('Verification failed: ${response.body}');
      }
    } catch (e) {
      // Dismiss loading indicator on error
      await EasyLoading.dismiss();
      // Handle network or other errors
      EasyLoading.showError('An error occurred: $e');
    }
  }

  void clearOtp() {
    otpController.clear();
    isOtpValid.value = false;
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}