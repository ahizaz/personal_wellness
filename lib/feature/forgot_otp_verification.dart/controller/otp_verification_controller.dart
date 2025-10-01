
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationController extends GetxController {
  final String email;
  OtpVerificationController({required this.email});

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

  void clearOtp() {
    otpController.clear();
    isOtpValid.value = false;
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }

  Future<bool> verifyOtpAndSaveToken() async {
    final otp = otpController.text.trim();
    debugPrint('OTP: $otp, Email: $email');
    if (email.isEmpty || otp.isEmpty) return false;
    EasyLoading.show(status: 'Verifying...');
    try {
     
      final response = await http.post(
        Uri.parse(Urls.verifyemail),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "oneTimeCode": int.tryParse(otp) ?? otp,
        }),
      );
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
      
        final accessToken = data['accessToken'] ?? data['data']?['accessToken'];
        debugPrint('AccessToken (direct): ${data['accessToken']}');
        debugPrint('AccessToken (nested): ${data['data']?['accessToken']}');
        // Use nested accessToken (your response structure)
        final actualToken = data['data']?['accessToken'];
        if (actualToken != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', actualToken);
          debugPrint('Token saved in SharedPreferences: $actualToken');
          return true;
        } else {
          EasyLoading.showError("No token received");
          debugPrint('No token received!');
          return false;
        }
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? "Verification failed";
        EasyLoading.showError(message);
        debugPrint('Verification failed. Message: $message');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error: $e');
      EasyLoading.showError("Network Error");
      return false;
    }
  }
}