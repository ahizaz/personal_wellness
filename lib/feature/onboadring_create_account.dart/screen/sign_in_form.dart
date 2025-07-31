import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/common/widgets/custom_textField.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/sign_in_controller.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/register_form.dart';
class SignInForm extends StatelessWidget {
  const SignInForm({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 482.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 33.h),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Sign in with SKINSpired',
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
                        controller: controller.emailController,
                        isFocused: controller.isEmailFocused,
                      ),
                      SizedBox(height: 12.h),
                      Obx(() => CustomButton(
                            text: 'Continue',
                            color: Color(0xff172601),
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: 'SFPro',
                              fontWeight: FontWeight.w600,
                              color: controller.hasText.value
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFF999999), // Gray when empty, white when text is present
                            ),
                            onTap: () {},
                          )),
                      SizedBox(height: 12.h),
                      CustomButton(
                        text: 'Create an account',
                        color: Color(0xffEDEEE6),
                        textStyle: TextStyle(
                          color: Color(0xff172601),
                          fontFamily: 'SFPro',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        onTap: () {
                          controller.clearEmail();
                          Get.to(()=>RegisterForm());
                        },
                      ),
                      SizedBox(height: 24.h,),
                      Row(
                        children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xff000000).withValues(alpha: 0.1),
                            height: 1,
                            thickness: 1,
                            endIndent: 10,
                          
                          ),
                        ),
                           SizedBox(width: 10.w),
                           Text("Or",style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff121221).withValues(alpha: 0.5),
                           ),),
                          Expanded(
                            child: Divider(
                                                  color: Color(0xff000000).withValues(alpha: 0.1),
                            height: 1,
                            thickness: 1,
                            indent: 10,
                            
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 21.h,),
                      CustomButton(text: "Continue with Google",textStyle: TextStyle(
                           color: Color(0xff172601),
                          fontFamily: 'SFPro',
                          fontSize: 17.5.sp,
                          fontWeight: FontWeight.w600,
                      ), color: Color(0xffEDEEE6),leadingIcon: Image.asset(IconPath.google,width: 20.w,height: 20.h,fit: BoxFit.cover,), onTap: (){

                      }),
                       SizedBox(height: 24.h,),
                      RichText(textAlign: TextAlign.center,
                      text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff3E4B2C),


                    ),

                    children: [
                      TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                         text: 'Terms of Service',
                         style: TextStyle(
                           decoration: TextDecoration.underline,
                            color: Color(0xff3E4B2C),
                         )
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                         text: 'Privacy Policy',
                         style: TextStyle(
                           decoration: TextDecoration.underline,
                            color: Color(0xff3E4B2C),
                         )
                      ),

                    ]
                      )),
                      SizedBox(height: 6.h,),
                      
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35.h),
            ],
          ),
        ),
      ),
    );
  }
}  