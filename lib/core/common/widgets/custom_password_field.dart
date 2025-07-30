import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/password_controller.dart';


class CustomPasswordField extends StatelessWidget {
  final PasswordController passwordController = Get.put(PasswordController());

  CustomPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE8E9E6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Obx(() => TextField(
                    controller: passwordController.passwordController,
                    obscureText: !passwordController.isPasswordVisible.value,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                    ),
                  )),
            ),
            Obx(() => GestureDetector(
                  onTap: passwordController.toggleVisibility,
                  child: Icon(
                    passwordController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
