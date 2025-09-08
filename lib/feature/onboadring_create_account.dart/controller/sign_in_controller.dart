import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final registerController = TextEditingController();


  final isRegisterEmailFocused = false.obs;
  final isEmailFocused = false.obs;


  final hasText = false.obs;
  final hasRegisterText = false.obs;
  var email = ''.obs;
  

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      hasText.value = emailController.text.isNotEmpty;
      email.value=emailController.text;
    });
    registerController.addListener((){
     hasRegisterText.value=registerController.text.isNotEmpty;
    });
  }

  void clearEmail() {
    emailController.clear();
    hasText.value = false;
    registerController.clear();
    hasRegisterText.value=false;
  }

  @override
  void onClose() {
    emailController.dispose();
    registerController.dispose();
    super.onClose();
  }
}
