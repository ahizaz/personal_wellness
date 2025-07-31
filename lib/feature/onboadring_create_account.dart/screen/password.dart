
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: 450.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              // Perform continue action
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
                           SizedBox(width: 4.w),
                           Text("Or",style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff121221).withValues(alpha: 0.5),
                           ),),
                           SizedBox(width: 4,),
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


                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
