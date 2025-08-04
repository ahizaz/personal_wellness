import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/account_personalization.dart/screen/display_name.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/widget/back_butoon_title.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/otp_verification_default_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationDefault extends StatelessWidget {
  const OtpVerificationDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationDefaultController());
    return Scaffold(
       resizeToAvoidBottomInset: false,
       body: Container(
        width: double.infinity,
        height: double.infinity,
           decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.accountBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
             width: double.infinity,
          
            decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(32.r),
            ),
            child: Padding(padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               SizedBox(height: 33.h),
               BackButtonWithTitle(title: 'OTP verification'),
               SizedBox(height: 33.h,),
               Center(
                child: Image.asset(ImagePath.otppic,width: 50.w,height: 50.h,fit: BoxFit.cover,),
               ),
               SizedBox(height: 24.h,),
               Text("Please enter the 6 digit OTP that was\n     sent to st***mos@gmail.com.",
                   style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3E4B2C),
                          fontSize: 17.sp,
                          fontFamily: 'SFPro',
                          
                        ),
               ),
               SizedBox(height: 24.h,),
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
                    color: Color(0xffEDEEE6),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xffEDEEE6)),

                  )
                ),
                pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                showCursor: true,
               ),
               SizedBox(height: 24.h,),
               Obx(()=>CustomButton(text: 
               "Verify",
               color: const Color(0xff172601),
               textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFPro',
                              color: controller.isOtpValid.value
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                onTap: controller.isOtpValid.value?(){
                  controller.clearOtp();
                  Get.to(()=>DisplayName());
                }
                :(){},
                )),

               SizedBox(height: 24.h,)
              ],
            ),
            ),
            )

          ],
        ),
            
        ),

       ),
    );
  }
}