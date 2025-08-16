import 'package:flutter/material.dart';
import 'package:get/get.dart';

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