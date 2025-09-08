import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/common/widgets/custom_password_field.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/password_controller.dart';

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PasswordController());
    final passwordController = Get.find<PasswordController>();

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
              child: SingleChildScrollView( // Allows scrolling if content is covered by keyboard
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
                          SizedBox(width: 70.w),
                          Center(
                            child: Text(
                              'Create Password',
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
                      CustomPasswordField(),
                      SizedBox(height: 12.h),
                      Obx(() {
                        final strength = passwordController.passwordStrength.value;
                        final bool isStrong = strength == 'strong';

                        return CustomButton(
                          text: 'Continue',
                          color: const Color(0xff172601),
                          onTap: () {
                            if (isStrong) {
                        passwordController.createUser();
                            }
                          },
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(isStrong ? 1.0 : 0.5),
                          ),
                        );
                      }),
                      SizedBox(height: 24.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff3E4B2C),
                          ),
                          children: [
                            const TextSpan(text: 'By continuing, you agree to our '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: const Color(0xff3E4B2C),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: const Color(0xff3E4B2C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}