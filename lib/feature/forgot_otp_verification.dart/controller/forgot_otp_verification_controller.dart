import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotOtpVerification extends GetxController{
  final forgotEmailController  = TextEditingController();
  final isForgotEmailFocused = false.obs;
  final hasForgotEmailText = false.obs;
  @override
  void onInit() {
    super.onInit();
    forgotEmailController.addListener((){
    hasForgotEmailText.value = forgotEmailController.text.isNotEmpty;
    });
  }

void clearForgotEmail(){
  forgotEmailController.clear();
  hasForgotEmailText.value = false;
}

  @override
  void onClose() {
   forgotEmailController.dispose();
    super.onClose();
  }
}