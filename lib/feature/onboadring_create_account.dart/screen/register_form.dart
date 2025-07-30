import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/common/widgets/custom_textField.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/sign_in_controller.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(SignInController());
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
        child: Padding(padding: EdgeInsets.symmetric(horizontal:17.w ),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.end,
          children: [
        Container(
          width: double.infinity,
            height: 405.h,
             decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(padding: EdgeInsets.symmetric(horizontal:20.w ),
                child: Column(
                  children: [
                     SizedBox(height: 33.h),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Create  SKINSprired  account',
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
                        CustomEmailTextField(controller: controller.registerController, isFocused: controller.hasRegisterText),
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
                        text: 'Sign In',
                        color: Color(0xffEDEEE6),
                        textStyle: TextStyle(
                          color: Color(0xff172601),
                          fontFamily: 'SFPro',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        onTap: () {
                          controller.clearEmail();
                          Get.back();
                       
                        },
                      ),



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