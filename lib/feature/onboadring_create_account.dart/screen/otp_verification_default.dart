import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/widget/back_butoon_title.dart';

class OtpVerificationDefault extends StatelessWidget {
  const OtpVerificationDefault({super.key});

  @override
  Widget build(BuildContext context) {
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
             height: 454.h,
            decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(32.r),
            ),
            child: Padding(padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
              children: [
               SizedBox(height: 33.h),
               BackButtonWithTitle(title: 'OTP verification'),
               SizedBox(height: 33.h,),
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