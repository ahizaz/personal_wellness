import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/controller/create_new_password_controller.dart';
import 'package:personal_wellness/feature/forgot_otp_verification.dart/widget/custom_create_newPass_field.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateNewPasswordController());
    final createNewPasswordController = Get.find<CreateNewPasswordController>();

    return Scaffold(

      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
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
                  children: [
                    SizedBox(height: 33.h),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Create a new password',
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
                    CustomCreateNewpassField(),
                    SizedBox(height: 12.h),
                    Obx(() {
                      final strength = createNewPasswordController.passwordStrength.value;
                      final bool isStrong = strength == 'strong';
              
                      return CustomButton(
                        text: 'Continue',
                        color: const Color(0xff172601),
                        onTap: () {
                          if (isStrong) {
                            createNewPasswordController.clearPassword();
                            Get.off(() => BottomNavbar());
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