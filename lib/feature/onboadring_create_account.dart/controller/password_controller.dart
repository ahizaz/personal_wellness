import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  final TextEditingController passwordController = TextEditingController();

  void toggleVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
