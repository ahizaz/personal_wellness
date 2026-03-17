
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/profile_accountseetings/controller/update_password_controller.dart';
import 'package:personal_wellness/feature/profile_accountseetings/widget/update_custom_password_field.dart';

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({super.key});
  @override
  Widget build(BuildContext context) {
    final UpdatePasswordController controller = Get.put(UpdatePasswordController());
     
    return Scaffold(
            backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
             BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
          SafeArea(child: Center(
            child: SingleChildScrollView(
               padding: EdgeInsets.only(
                  top: 60.h,
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(32.r),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                         width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                      padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 25.h,
                    ),
                    child: Column(
                            mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Security settings',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
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
                        SizedBox(height: 24.h),
                        Text(
                          "Update password",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff172601),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Keep your account safe — use a strong \npassword and update it regularly.",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff3E4B2C),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 24.h),
                Obx(() => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.hasText.value
                              ? Color(0xff485908)
                              : const Color(0xffE8E9E6),
                         width:controller.hasText.value?3:1,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3),
                        child: Row(
                          children: [
                            
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  controller: controller.passwordController,
                                  obscureText: controller.obscureText.value, // Hidden when obscureText is true
                                  decoration: InputDecoration(
                                    hintText: 'Current Password',
                                    hintStyle: TextStyle(
                                      fontFamily: 'SFPro',
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontSize: 16.sp,
                                    color: const Color(0xff172601),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.togglePasswordVisibility(); // Toggle visibility
                              },
                              child: Obx(
                                () => Icon(
                                  controller.obscureText.value ? Icons.visibility_off_outlined : Icons.visibility,
                                  size: 24.w,
                                  color: const Color(0xff78816C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(height: 12.h,),
                    UpdatePasswordFiled(),
                    //newCOnfrim
                    SizedBox(height: 12.h,),
                      Obx(() => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.hasNewConfirmText.value
                              ? Color(0xff485908)
                              : const Color(0xffE8E9E6),
                         width:controller.hasNewConfirmText.value?3:1,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3),
                        child: Row(
                          children: [
                    
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  controller: controller.confirmnewController,
                                  obscureText: controller.obscureConfirmNewText.value, // Hidden when obscureText is true
                                  decoration: InputDecoration(
                                    hintText: 'Confirm New Password',
                                    hintStyle: TextStyle(
                                      fontFamily: 'SFPro',
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontSize: 16.sp,
                                    color: const Color(0xff172601),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.togglePasswordVisibility(); // Toggle visibility
                              },
                              child: Obx(
                                () => Icon(
                                  controller.obscureConfirmNewText.value ? Icons.visibility_off_outlined : Icons.visibility,
                                  size: 24.w,
                                  color: const Color(0xff78816C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(height: 24.h,),
                    Obx(() => CustomButton(
      text: "Save Changes",
      textStyle: TextStyle(
        fontFamily: "SFPro",
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: controller.allFieldsFilled.value
            ? const Color(0xffFFFFFF)
            : const Color(0xffA0A0A0), // Greyed-out text when disabled
      ),
      color:Color(0xff172601), // Greyed-out background when disabled
      onTap: controller.allFieldsFilled.value
          ? () {
              controller.updatePassword();
            }
          : (){}, // Disable onTap when fields are not filled
    )),
                    
                  
                
                      ],
                    ),
                    ),
                ),
            ),
          ))

        ],
      ),
    );
  }
}