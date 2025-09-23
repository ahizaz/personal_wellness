
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/controller/create_new_password_controller.dart';

class CustomCreateNewpassField extends StatelessWidget {
  final CreateNewPasswordController createNewPasswordController = Get.find<CreateNewPasswordController>();

  CustomCreateNewpassField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final strength = createNewPasswordController.passwordStrength.value;
      final borderColor = strength != 'none' ? const Color(0xff172601) : const Color(0xffE8E9E6);

      // Confirm Password border: gray if empty, green if not empty
      final confirmBorderColor = createNewPasswordController.confirmPasswordController.text.isNotEmpty
          ? const Color(0xff172601)
          : const Color(0xffE8E9E6);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Password Field
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: createNewPasswordController.passwordController,
                      obscureText: !createNewPasswordController.isPasswordVisible.value,
                      decoration: const InputDecoration(
                        hintText: "New Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: createNewPasswordController.toggleVisibility,
                    child: Icon(
                      createNewPasswordController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Password Strength Indicator Bars
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildStrengthBar(index: 0, strength: strength),
              SizedBox(width: 6.w),
              _buildStrengthBar(index: 1, strength: strength),
              SizedBox(width: 6.w),
              _buildStrengthBar(index: 2, strength: strength),
            ],
          ),

          SizedBox(height: 4.h),

          // Strength Label
          Text(
            strength.capitalizeFirst ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: _getStrengthColor(strength),
            ),
          ),

          SizedBox(height: 16.h),

          // Confirm Password Field
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: confirmBorderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: createNewPasswordController.confirmPasswordController,
                      obscureText: !createNewPasswordController.isConfirmPasswordVisible.value,
                      decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: createNewPasswordController.toggleConfirmVisibility,
                    child: Icon(
                      createNewPasswordController.isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          // Match Label
          createNewPasswordController.passwordsMatch.value
              ? SizedBox()
              : Text(
                  "Passwords do not match",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.redAccent,
                  ),
                ),
        ],
      );
    });
  }

  // Builds each individual bar with its own color logic
  Widget _buildStrengthBar({required int index, required String strength}) {
    Color fillColor = const Color(0xffE8E9E6); // default gray

    if (strength == 'easy' && index == 0) {
      fillColor = _getStrengthColor(strength);
    } else if (strength == 'medium' && (index == 0 || index == 1)) {
      fillColor = _getStrengthColor(strength);
    } else if (strength == 'strong') {
      fillColor = _getStrengthColor(strength);
    }

    return Container(
      width: 100.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Color _getStrengthColor(String strength) {
    switch (strength) {
      case 'easy':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}