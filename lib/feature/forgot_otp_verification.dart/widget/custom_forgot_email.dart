import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/controller/forgot_otp_verification_controller.dart';

class CustomForgotEmailTextField extends StatelessWidget{
  final TextEditingController controller;
  final RxBool isFocused;
  const CustomForgotEmailTextField({
   super.key,
   required this.controller,
   required this.isFocused,

  });
  @override
  Widget build(BuildContext context) {
 final forgotPasswordController = Get.put(ForgotOtpVerification());
 return Focus(
  onFocusChange: (focus){
    isFocused.value=focus;
  }
  ,child: Obx((){
return Container(
decoration: BoxDecoration(
  border: Border.all(
  color:isFocused.value|| controller.text.isNotEmpty?const Color(0xff485908):const Color(0xffE8E9E6),  width: isFocused.value || controller.text.isNotEmpty ? 3.w : 1.w,

  ),
  borderRadius: BorderRadius.circular(12.r),
),
child: TextField(
  controller: controller,
  style: TextStyle(
    fontSize: 17.sp,
     fontFamily: 'SFPro',
     fontWeight: FontWeight.w400,
      color: const Color(0xff172601),
  ),
  decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
    border: InputBorder.none,
     hintText: 'Email Address',
     hintStyle: TextStyle(
      fontSize: 17.sp,
      fontFamily: 'SFPro',
        fontWeight: FontWeight.w400,
         color: const Color(0xff999999),
     ),
     floatingLabelBehavior: FloatingLabelBehavior.never,
     prefixIcon: Icon(
     Icons.email_outlined,
      color: const Color(0xff172601),
      size: 20.sp,
     ),
     suffixIcon: forgotPasswordController.hasForgotEmailText.value?GestureDetector(
      onTap:forgotPasswordController.clearForgotEmail,
      child: Icon(Icons.clear,color: Colors.grey,size: 20.sp,),
     )
     :null,


  ),
  keyboardType: TextInputType.emailAddress,
),
);

  }));
  }
}