
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  final TextEditingController passwordController = TextEditingController();
  RxString passwordStrength = 'none'.obs; // 'none', 'easy', 'medium', 'strong'

  void toggleVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength.value = 'none';
    } else if (password.length >= 8 &&
        RegExp(r'(?=.*[A-Z])').hasMatch(password) &&
        RegExp(r'(?=.*[a-z])').hasMatch(password) &&
        RegExp(r'(?=.*[0-9])').hasMatch(password) &&
        RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      passwordStrength.value = 'strong';
    } else if (password.length >= 6 &&
        RegExp(r'(?=.*[A-Za-z])').hasMatch(password) &&
        RegExp(r'(?=.*[0-9])').hasMatch(password)) {
      passwordStrength.value = 'medium';
    } else {
      passwordStrength.value = 'easy';
    }
  }

  @override
  void onInit() {
    passwordController.addListener(() {
      checkPasswordStrength(passwordController.text);
    });
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}