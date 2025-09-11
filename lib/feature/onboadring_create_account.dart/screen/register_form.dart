import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/common/widgets/custom_terms_text.dart';
import 'package:personal_wellness/core/common/widgets/custom_textField.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/sign_in_controller.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/password.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

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
                padding: EdgeInsets.symmetric(horizontal: 20.w,),
                child: Column(
               
                  children: [
                    SizedBox(height: 33.h),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Create SKINSprired account',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff172601),
                                fontFamily: 'SFPro',
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            IconPath.cross,
                            width: 32.w,
                            height: 32.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 33.h),
                    CustomEmailTextField(
                      controller: controller.registerController,
                      isFocused: controller.isRegisterEmailFocused,
                    ),
                    SizedBox(height: 12.h),
                    Obx(() => CustomButton(
                          text: 'Continue',
                          color: const Color(0xff172601),
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.w600,
                            color: controller.hasRegisterText.value
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF999999),
                          ),
                          onTap: () {
                            
                            Get.to(() => Password());
                         
                            
                          },
                        )),
                    SizedBox(height: 12.h),
                    CustomButton(
                      text: 'Sign In',
                      color: const Color(0xffEDEEE6),
                      textStyle: TextStyle(
                        color: const Color(0xff172601),
                        fontFamily: 'SFPro',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      onTap: () {
                        controller.clearEmail();
                        Get.back();
                      },
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: const Color(0xff000000).withAlpha(25),
                            height: 1,
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          "Or Continue with",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff121221).withAlpha(128),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: const Color(0xff000000).withAlpha(25),
                            height: 1,
                            thickness: 1,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 21.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Continue with Google",
                            textStyle: TextStyle(
                              color: const Color(0xff172601),
                              fontFamily: 'SFPro',
                              fontSize: 17.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            color: const Color(0xffEDEEE6),
                            leadingIcon: Image.asset(
                              IconPath.google,
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                  
                           },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    CustomTermsText(),
                    SizedBox(height: 24,)
                            
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