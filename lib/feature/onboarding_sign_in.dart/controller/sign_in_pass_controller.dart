import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/core/urls/urls.dart';

class SignInPassController extends GetxController {
  var obscureText = true.obs;
  final TextEditingController signInPasswordController = TextEditingController();
  var hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    signInPasswordController.addListener(() {
      hasText.value = signInPasswordController.text.isNotEmpty;
    });
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<bool> login(String email, String password) async {
    const String apiUrl = '${Urls.baseUrl}/auth/login';
    try {
      // Show loading indicator
      await EasyLoading.show(
        status: 'Logging in...',
        maskType: EasyLoadingMaskType.black, // Prevent interaction during loading
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Dismiss loading indicator
      await EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Successful login
        print('Login successful: ${response.body}');
        EasyLoading.showSuccess('Login successful!');
        return true;
      } else {
        // Handle error
        print('Login failed: ${response.statusCode} - ${response.body}');
        EasyLoading.showError('Invalid email or password');
        return false;
      }
    } catch (e) {
      // Dismiss loading indicator on error
      await EasyLoading.dismiss();
      print('Error during login: $e');
      EasyLoading.showError('Something went wrong. Please try again.');
      return false;
    }
  }

  @override
  void onClose() {
    signInPasswordController.dispose();
    super.onClose();
  }
}