
// import 'package:flutter/widgets.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:personal_wellness/core/urls/urls.dart';

// class CreateNewPasswordController extends GetxController {
//   RxBool isPasswordVisible = false.obs;
//   RxBool isConfirmPasswordVisible = false.obs;

//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   RxString passwordStrength = 'none'.obs;
//   RxBool passwordsMatch = false.obs;
//   RxBool isLoading = false.obs;

//   void toggleVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   void toggleConfirmVisibility() {
//     isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
//   }

//   void checkPasswordStrength(String password) {
//     if (password.isEmpty) {
//       passwordStrength.value = 'none';
//     } else if (password.length >= 8 &&
//         RegExp(r'(?=.*[A-Z])').hasMatch(password) &&
//         RegExp(r'(?=.*[a-z])').hasMatch(password) &&
//         RegExp(r'(?=.*[0-9])').hasMatch(password) &&
//         RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
//       passwordStrength.value = 'strong';
//     } else if (password.length >= 6 &&
//         RegExp(r'(?=.*[A-Za-z])').hasMatch(password) &&
//         RegExp(r'(?=.*[0-9])').hasMatch(password)) {
//       passwordStrength.value = 'medium';
//     } else {
//       passwordStrength.value = 'easy';
//     }
//   }

//   void checkPasswordsMatch() {
//     passwordsMatch.value = passwordController.text == confirmPasswordController.text &&
//         passwordController.text.isNotEmpty &&
//         confirmPasswordController.text.isNotEmpty;
//   }

//   void clearPassword() {
//     passwordController.clear();
//     confirmPasswordController.clear();
//     passwordStrength.value = 'none';
//     passwordsMatch.value = false;
//   }

//   Future<bool> resetPasswordApiCall() async {
//     final String url = Urls.resetpassword; 
//       isLoading.value = true;
//     EasyLoading.show(status: 'Resetting password...');
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "newPassword": passwordController.text,
//           "confirmPassword": confirmPasswordController.text,
//         }),
//       );
//       isLoading.value = false;
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         Get.snackbar("Error", "Reset failed: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar("Error", "Network error: $e");
//       return false;
//     }
//   }
//   @override
//   void onInit() {
//     passwordController.addListener(() {
//       checkPasswordStrength(passwordController.text);
//       checkPasswordsMatch();
//     });
//     confirmPasswordController.addListener(() {
//       checkPasswordsMatch();
//     });
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateNewPasswordController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  RxString passwordStrength = 'none'.obs;
  RxBool passwordsMatch = false.obs;
  RxBool isLoading = false.obs;

  void toggleVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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

  void checkPasswordsMatch() {
    passwordsMatch.value = passwordController.text == confirmPasswordController.text &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  void clearPassword() {
    passwordController.clear();
    confirmPasswordController.clear();
    passwordStrength.value = 'none';
    passwordsMatch.value = false;
  }

  Future<bool> resetPasswordApiCall() async {
    final String url = Urls.resetpassword; // Use the constant
    isLoading.value = true;
    EasyLoading.show(status: 'Resetting password...');

    try {
      // Retrieve the accessToken from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        isLoading.value = false;
        EasyLoading.dismiss();
        EasyLoading.showError("No access token found");
        print('No access token found in SharedPreferences');
        return false;
      }

      // Make the HTTP POST request with Bearer Token
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // Add Bearer Token
        },
        body: jsonEncode({
          "newPassword": passwordController.text,
          "confirmPassword": confirmPasswordController.text,
        }),
      );

      print('Reset Password Response Code: ${response.statusCode}');
      print('Reset Password Response Body: ${response.body}');

      isLoading.value = false;
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        print('Password reset successful');
        EasyLoading.showSuccess("Password reset successful");
        return true;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? "Reset failed";
        EasyLoading.showError(message);
        print('Reset failed: $message');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      print('Error: $e');
      EasyLoading.showError("Network error: $e");
      return false;
    }
  }

  @override
  void onInit() {
    passwordController.addListener(() {
      checkPasswordStrength(passwordController.text);
      checkPasswordsMatch();
    });
    confirmPasswordController.addListener(() {
      checkPasswordsMatch();
    });
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}