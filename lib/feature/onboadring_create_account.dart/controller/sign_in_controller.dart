import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final isEmailFocused = false.obs;
  final hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      hasText.value = emailController.text.isNotEmpty;
    });
  }

  void clearEmail() {
    emailController.clear();
    hasText.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
