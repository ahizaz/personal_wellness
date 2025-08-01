import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController{
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
   // Placeholder for future API call to verify OTP
  Future<void> verifyOtp() async {
    // TODO: Implement API call here in the future
    // Example: await apiService.verifyOtp(otpController.text);
    print('OTP submitted for verification: ${otpController.text}');
    // Placeholder logic - can be replaced with actual API integration later
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