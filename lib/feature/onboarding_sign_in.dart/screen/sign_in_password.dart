import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/common/widgets/custom_terms_text.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/screen/forgot_password.dart';
import 'package:personal_wellness/feature/onboarding_sign_in.dart/controller/sign_in_pass_controller.dart';

class SignInPassword extends StatelessWidget {
  const SignInPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInPassController controller = Get.put(SignInPassController()); // Initialize SignInPassController

    return Scaffold(
      // Prevents the entire screen from resizing with the keyboard
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.accountBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom Form Fixed
          Positioned(
            bottom: 5.h, // Initial position near the bottom
            left: 16.w,
            right: 16.w,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
               // Prevents unnecessary expansion
                  children: [
                    SizedBox(height: 33.h),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage(IconPath.back),
                                height: 32.h,
                                width: 32.h,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 50.w),
                        Center(
                          child: Text(
                            'Sign in with SKINSpired',
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff172601),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 33.h),
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffE8E9E6),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            Image.asset(
                              IconPath.lock,
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  controller: controller.signInPasswordController,
                                  obscureText: controller.obscureText.value, // Hidden when obscureText is true
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontFamily: 'SFPro',
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontSize: 16.sp,
                                    color: const Color(0xff172601),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.togglePasswordVisibility(); // Toggle visibility
                              },
                              child: Obx(
                                () => Icon(
                                  controller.obscureText.value ? Icons.visibility_off_outlined : Icons.visibility,
                                  size: 24.w,
                                  color: const Color(0xff78816C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Obx(() => CustomButton(
                      text: 'Continue',
                      textStyle: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w600,
                        color: controller.hasText.value ? const Color(0xffFFFFFF) : const Color(0xffff999999),
                      ),
                      color: const Color(0xff172601),
                      onTap: () {
                        controller.signInPasswordController.clear();
                        Get.off(() => BottomNavbar());
                      },
                    )),
                    SizedBox(height: 13.h),
                    CustomButton(
                      text: "Forgot Password",
                      textStyle: TextStyle(
                        color: const Color(0xff485908),
                        fontFamily: 'SFPro',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      color: const Color(0xffEDEEE6),
                      onTap: () {
                        Get.to(() => ForgotPassword());
                      },
                    ),
                    SizedBox(height: 24.h),
                    CustomTermsText(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}