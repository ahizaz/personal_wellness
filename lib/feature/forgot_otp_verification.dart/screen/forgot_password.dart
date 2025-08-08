import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/controller/forgot_otp_verification_controller.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/screen/otp_verification.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/widget/back_butoon_title.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/widget/custom_forgot_email.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotOtpVerification());

    return Scaffold(
     
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.accountBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom Form Fixed
          Positioned(
            bottom: 5.h, // Initial position near the bottom
            left: 16.w, // Matches the padding from the original design
            right: 16.w, // Matches the padding from the original design
            child: SafeArea(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 33.h),
                    const BackButtonWithTitle(
                      title: 'Forgot Password',
                    ),
                    SizedBox(height: 33.h),
                       Center(
                    child: Image(image: AssetImage(ImagePath.forgotlock),width: 48.w,height: 48.h,fit: BoxFit.cover,),
                   ),
                   SizedBox(height: 24.h,),
                    Center(
                      child: Text(
                        "Please submit your registered email\n    address to reset your password",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff3E4B2C),
                          fontSize: 17.sp,
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    CustomForgotEmailTextField(
                      controller: controller.forgotEmailController,
                      isFocused: controller.isForgotEmailFocused,
                    ),
                    SizedBox(height: 12.h),
                    Obx(() => CustomButton(
                          text: 'Submit',
                          color: const Color(0xff172601),
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.w600,
                            color: controller.hasForgotEmailText.value
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF999999),
                          ),
                          onTap: controller.hasForgotEmailText.value
                              ? () {
                                  controller.clearForgotEmail();
                                  Get.to(() => OtpVerification());
                                }
                              : () {}, // Disable tap when no text
                        )),
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