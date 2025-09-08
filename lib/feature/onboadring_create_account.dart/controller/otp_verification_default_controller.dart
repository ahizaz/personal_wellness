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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
        // Success: Clear OTP and navigate to DisplayName
        clearOtp();
        Get.to(() => DisplayName()); // Use named route if defined, or Get.to(() => DisplayName());
      } else {
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