import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/account_personalization.dart/controller/personalization_controller.dart';
import 'package:personal_wellness/feature/account_personalization.dart/screen/date_of_birth.dart';
import 'package:personal_wellness/feature/account_personalization.dart/widget/custom_display_nametextfield.dart';

class DisplayName extends StatelessWidget {
  const DisplayName({super.key});

  @override
  Widget build(BuildContext context) {
    final personalizationController = Get.find<PersonalizationController>();

    return Scaffold(
       // Prevents the entire screen from resizing with the keyboard
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
              child: SingleChildScrollView( // Allows scrolling if content is covered by keyboard
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                      SizedBox(height: 28.h),
                      Center(
                        child: Text(
                          "Hi there",
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff172601),
                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          "What should we call you?",
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff172601),
                          ),
                        ),
                      ),
                      SizedBox(height: 13.h),
                      CustomDisplayNameTextField(
                        controller: personalizationController.displayNameController,
                        isFocused: personalizationController.isDisplayNameFocused,
                        hintText: 'First name',
                      ),
                      SizedBox(height: 12.h),
                      CustomDisplayNameTextField(
                        controller: personalizationController.lastNameController,
                        isFocused: personalizationController.isLastNameFocused,
                        hintText: 'Last Name',
                      ),
                      SizedBox(height: 24.h),
                      Obx(() => Row(
                            children: [
                              Expanded(
                                child: Opacity(
                                  opacity: personalizationController.isFormValid.value ? 1.0 : 0.5,
                                  child: CustomButton(
                                    text: "Continue 1/5",
                                    color: const Color(0xff172601),
                                    onTap: personalizationController.isFormValid.value
                                        ? () {
                                            Get.to(() => const DateOfBirth());
                                          }
                                        : () {}, // Disable button when form is invalid
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomButton(
                                  text: "Skip",
                                  color: const Color(0xffEDEEE6),
                                  textStyle: TextStyle(
                                    color: const Color(0xff172601),
                                    fontFamily: "SFPro",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onTap: () {
                                    personalizationController.clearAllData();
                                    Get.to(() => const DateOfBirth());
                                  },
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}