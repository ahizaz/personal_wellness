
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/sign_in_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/core/urls/urls.dart';

class UpdatePasswordController extends GetxController {
  var obscureText = true.obs;
  var obscureConfirmNewText = true.obs;
  RxBool isPasswordVisible = false.obs;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmnewController = TextEditingController();
  RxString passwordStrength = 'none'.obs;
  var hasText = false.obs;
  var hasNewConfirmText = false.obs;
  var allFieldsFilled = false.obs; // New reactive boolean to track all fields

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

  void clearPassword() {
    newpasswordController.clear();
    passwordStrength.value = 'none';
  }

  Future<void> updatePassword() async {
    if (newpasswordController.text != confirmnewController.text) {
      Get.snackbar('Error', 'New password and confirmation do not match');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken'); // Assuming the token is stored under 'accessToken' key
    if (token == null) {
      Get.snackbar('Error', 'No authentication token found');
      return;
    }

    const String apiUrl = '${Urls.baseUrl}/auth/change-password';
    final Uri apiUri = Uri.parse(apiUrl);

    EasyLoading.show(status: 'Updating password...');

    try {
      final response = await http.post(
        apiUri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'currentPassword': passwordController.text,
          'newPassword': newpasswordController.text,
          'confirmPassword': confirmnewController.text,
        }),
      );

      if (response.statusCode == 200) {
        await prefs.remove('accessToken');
        await prefs.remove('userId');
       Get.offAll(()=>SignInForm()); // Assuming '/login' is the route name for the login screen
      } else {
        Get.snackbar('Error', 'Failed to update password: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onInit() {
    super.onInit();

    passwordController.addListener(checkAllFields);
    newpasswordController.addListener(checkAllFields);
    confirmnewController.addListener(checkAllFields);

    passwordController.addListener(() {
      hasText.value = passwordController.text.isNotEmpty;
    });
    newpasswordController.addListener(() {
      checkPasswordStrength(newpasswordController.text);
    });
    confirmnewController.addListener(() {
      hasNewConfirmText.value = confirmnewController.text.isNotEmpty;
    });
  }

  void checkAllFields() {
    allFieldsFilled.value = passwordController.text.isNotEmpty &&
        newpasswordController.text.isNotEmpty &&
        confirmnewController.text.isNotEmpty;
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
    obscureConfirmNewText.value = !obscureConfirmNewText.value;
  }

  @override
  void onClose() {
    passwordController.dispose();
    newpasswordController.dispose();
    confirmnewController.dispose();
    super.onClose();
  }
}