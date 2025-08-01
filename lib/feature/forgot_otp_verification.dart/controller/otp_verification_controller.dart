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