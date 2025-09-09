
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/core/urls/urls.dart';

import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/sign_in_controller.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/privacy_policy_terms.dart';
//regester
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

  Future<void> createUser() async {
    final signInController = Get.find<SignInController>();
    final email = signInController.email.value;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
    EasyLoading.showError('Email or password cannot be empty');
      return;
    }

    try {
      // Show loading indicator
      await EasyLoading.show(status: 'Creating account...');

      final response = await http.post(
        Uri.parse(Urls.register), // Use the register endpoint from Urls class
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Dismiss loading indicator
      await EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success: Clear fields and navigate to PrivacyPolicyTerms
        clear();
        Get.to(() => PrivacyPolicyTerms());
      } else {
        // Handle error response
       EasyLoading.showError('Email or password cannot be empty');
      }
    } catch (e) {
      // Dismiss loading indicator on error
      await EasyLoading.dismiss();
      // Handle network or other errors
     EasyLoading.showError('An error occurred: $e');
    }
  }

  void clear() {
    passwordController.clear();
    passwordStrength.value = 'none';
    isPasswordVisible.value = false;
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