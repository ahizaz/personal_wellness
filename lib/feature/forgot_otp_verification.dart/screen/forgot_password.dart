import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
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
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.accountBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 33.h),
                      const BackButtonWithTitle(
                        title: 'Forgot Password',
                      ),
                      SizedBox(height: 33.h),
                      Text(
                        "Now worry.We're here to helo you.\nSubmit your registered email address to\nreset your password.",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3E4B2C),
                          fontSize: 17.sp,
                          fontFamily: 'SFPro',
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
                            color:Color(0xff172601),
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: 'SFPro',
                              fontWeight: FontWeight.w600,
                              color: controller.hasForgotEmailText.value
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFF999999),
                            ),
                            onTap: controller.hasForgotEmailText.value
                                ? () {
                                  controller.clearForgotEmail();
                                 Get.to(()=>OtpVerification());
                                  }
                                : () {}, // Disable tap when no text
                          )),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}