import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  final TextEditingController passwordController = TextEditingController();
  RxBool hasText = false.obs;

  void toggleVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    passwordController.addListener(() {
      hasText.value = passwordController.text.isNotEmpty;
    });
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}