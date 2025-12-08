import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/question_answer_controller.dart';

class QuestionAnswer extends StatelessWidget {
  const QuestionAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionAnswerController());

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
            bottom: 5.h,
            left: 16.w,
            right: 16.w,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Question and Answer',
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

                      // Question 1: Why are you using this apps?
                      Text(
                        'Why are you using this apps?',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff172601),
                          fontFamily: 'SFPro',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.hasWhyUsingAppText.value
                                  ? const Color(0xff485908)
                                  : const Color(0xffE8E9E6),
                              width: controller.hasWhyUsingAppText.value ? 3.w : 1.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: TextField(
                            controller: controller.whyUsingAppController,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                              fontFamily: 'SFPro',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tell us why you are using this app...',
                              hintStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff999999),
                                fontFamily: 'SFPro',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Question 2: Are you 18+?
                      Text(
                        'Are you 18+?',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff172601),
                          fontFamily: 'SFPro',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.setAgeVerification('yes');
                                },
                                child: Container(
                                  height: 54.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller.ageVerification.value == 'yes'
                                          ? const Color(0xff485908)
                                          : const Color(0xffE8E9E6),
                                      width: controller.ageVerification.value == 'yes' ? 3.w : 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: controller.ageVerification.value == 'yes'
                                        ? const Color(0xff485908).withOpacity(0.1)
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: controller.ageVerification.value == 'yes'
                                            ? const Color(0xff485908)
                                            : const Color(0xff999999),
                                        fontFamily: 'SFPro',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.setAgeVerification('no');
                                },
                                child: Container(
                                  height: 54.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller.ageVerification.value == 'no'
                                          ? const Color(0xff485908)
                                          : const Color(0xffE8E9E6),
                                      width: controller.ageVerification.value == 'no' ? 3.w : 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: controller.ageVerification.value == 'no'
                                        ? const Color(0xff485908).withOpacity(0.1)
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: controller.ageVerification.value == 'no'
                                            ? const Color(0xff485908)
                                            : const Color(0xff999999),
                                        fontFamily: 'SFPro',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Question 3: Additional question 1
                      Text(
                        'What are your main skincare goals?',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff172601),
                          fontFamily: 'SFPro',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.hasQuestion1Text.value
                                  ? const Color(0xff485908)
                                  : const Color(0xffE8E9E6),
                              width: controller.hasQuestion1Text.value ? 3.w : 1.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: TextField(
                            controller: controller.question1Controller,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                              fontFamily: 'SFPro',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your skincare goals...',
                              hintStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff999999),
                                fontFamily: 'SFPro',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Question 4: Additional question 2
                      Text(
                        'How did you hear about us?',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff172601),
                          fontFamily: 'SFPro',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.hasQuestion2Text.value
                                  ? const Color(0xff485908)
                                  : const Color(0xffE8E9E6),
                              width: controller.hasQuestion2Text.value ? 3.w : 1.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: TextField(
                            controller: controller.question2Controller,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                              fontFamily: 'SFPro',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tell us how you found us...',
                              hintStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff999999),
                                fontFamily: 'SFPro',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Submit Button
                      Obx(
                        () => CustomButton(
                          text: 'Submit',
                          color: const Color(0xff172601),
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.w600,
                            color: controller.isFormValid
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF999999),
                          ),
                          onTap: () {
                            if (controller.isFormValid) {
                              controller.submitAnswers();
                            }
                          },
                        ),
                      ),
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
