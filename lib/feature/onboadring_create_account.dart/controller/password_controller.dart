// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class PasswordController extends GetxController {
// //   RxBool isPasswordVisible = false.obs;
// //   final TextEditingController passwordController = TextEditingController();
// //   RxBool hasText = false.obs;

// //   void toggleVisibility() {
// //     isPasswordVisible.value = !isPasswordVisible.value;
// //   }

// //   @override
// //   void onInit() {
// //     passwordController.addListener(() {
// //       hasText.value = passwordController.text.isNotEmpty;
// //     });
// //     super.onInit();
// //   }

// //   @override
// //   void onClose() {
// //     passwordController.dispose();
// //     super.onClose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PasswordController extends GetxController {
//   RxBool isPasswordVisible = false.obs;
//   final TextEditingController passwordController = TextEditingController();
//   RxString passwordStrength = 'none'.obs; // 'none', 'easy', 'medium', 'strong'

//   void toggleVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   void checkPasswordStrength(String password) {
//     if (password.isEmpty) {
//       passwordStrength.value = 'none';
//     } else if (password.length < 6) {
//       passwordStrength.value = 'easy';
//     } else if (password.length >= 6 &&
//         password.contains(RegExp(r'[A-Za-z]')) &&
//         password.contains(RegExp(r'[0-9]'))) {
//       passwordStrength.value = 'medium';
//     } else if (password.length >= 8 &&
//         password.contains(RegExp(r'[A-Z]')) &&
//         password.contains(RegExp(r'[a-z]')) &&
//         password.contains(RegExp(r'[0-9]')) &&
//         password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
//       passwordStrength.value = 'strong';
//     } else {
//       passwordStrength.value = 'easy';
//     }
//   }

//   @override
//   void onInit() {
//     passwordController.addListener(() {
//       checkPasswordStrength(passwordController.text);
//     });
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     passwordController.dispose();
//     super.onClose();
//   }
// }
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