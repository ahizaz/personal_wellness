
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        // Parse the response
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          // Extract accessToken
          String accessToken = responseData['data']['accessToken'];
           String userId = responseData['data']['user']['_id'];
          print('Access Token: $accessToken');
           print('User ID: $userId');

          // Save accessToken to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('userId', userId); 

          // Optional: Save other data if needed, e.g., refreshToken or user info
          // String refreshToken = responseData['data']['refreshToken'];
          // await prefs.setString('refreshToken', refreshToken);

          print('Login successful: ${response.body}');
          EasyLoading.showSuccess('Login successful!');
          return true;
        } else {
          print('Login failed: Unexpected response format');
          EasyLoading.showError('Invalid response from server');
          return false;
        }
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

  // Optional: Method to retrieve the accessToken later
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  void onClose() {
    signInPasswordController.dispose();
    super.onClose();
  }
}