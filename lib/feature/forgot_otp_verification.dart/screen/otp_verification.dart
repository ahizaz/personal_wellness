import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/controller/otp_verification_controller.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/screen/create_new_password.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/widget/back_butoon_title.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatelessWidget {
   final String email;
  const OtpVerification({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController(email: email));
    debugPrint('OTPVerification email: ${controller.email}');
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
            bottom: 5.h,
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
                      title: 'OTP verification',
                    ),
                    SizedBox(height: 33.h),
                              Center(
                    child: Image(image: AssetImage(ImagePath.otppic,),width: 48.w,height: 48.h,fit: BoxFit.cover,),
                   ),
                   SizedBox(height: 24.h,),
                    Center(
                      child: Text(
                        "Please enter the 6-digit OTP that was sent to your account",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff3E4B2C),
                          fontSize: 17.sp,
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Pinput(
                      length: 6,
                      controller: controller.otpController,
                      defaultPinTheme: PinTheme(
                        width: 48.w,
                        height: 56.h,
                        textStyle: TextStyle(
                          fontSize: 28.sp,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff172601),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffEDEEE6),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: const Color(0xffEDEEE6)),
                        ),
                      ),
                      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                      showCursor: true,
                    ),
                    SizedBox(height: 24.h),
                    Obx(() => CustomButton(
                          text: "Verify",
                          color: const Color(0xff172601), // Consistent background color
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFPro',
                            color: controller.isOtpValid.value
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5), // Text opacity
                          ),
                          onTap: controller.isOtpValid.value
                              ? ()async {
                                 bool success = await controller.verifyOtpAndSaveToken();
                                     if (success) {
                  controller.clearOtp();
                  Get.to(() => CreateNewPassword());
                }
                                }
                              : () {}, // Disable tap when invalid
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