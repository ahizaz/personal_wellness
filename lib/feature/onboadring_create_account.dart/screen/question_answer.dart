import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
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
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.h),
                          child: CircularProgressIndicator(
                            color: const Color(0xff485908),
                          ),
                        ),
                      );
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading questions',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xff999999),
                                  fontFamily: 'SFPro',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () {
                                  controller.fetchQuestions();
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
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
                          
                            ],
                          ),
                          SizedBox(height: 33.h),

                          // Question 1: Gender (from API)
                          if (controller.genderQuestion != null) ...[
                            Text(
                              controller.genderQuestion!['question'] ?? '',
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
                              () {
                                final genderOptions = controller.genderOptions;
                                if (genderOptions.length <= 3) {
                                  // Display in a row if 3 or fewer options
                                  return Row(
                                    children: [
                                      ...genderOptions.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final option = entry.value;
                                        final isSelected = controller.selectedGender.value == option;
                                        return Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: index < genderOptions.length - 1 ? 12.w : 0,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.setGender(option);
                                              },
                                              child: Container(
                                                height: 54.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? const Color(0xff485908)
                                                        : const Color(0xffE8E9E6),
                                                    width: isSelected ? 3.w : 1.w,
                                                  ),
                                                  borderRadius: BorderRadius.circular(12.r),
                                                  color: isSelected
                                                      ? const Color(0xff485908).withValues(alpha: .1)
                                                      : Colors.transparent,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    option,
                                                    style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: isSelected
                                                          ? const Color(0xff485908)
                                                          : const Color(0xff999999),
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  );
                                } else {
                                  // Display in a column if more than 3 options
                                  return Column(
                                    children: genderOptions.map((option) {
                                      final isSelected = controller.selectedGender.value == option;
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.setGender(option);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 54.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isSelected
                                                    ? const Color(0xff485908)
                                                    : const Color(0xffE8E9E6),
                                                width: isSelected ? 3.w : 1.w,
                                              ),
                                              borderRadius: BorderRadius.circular(12.r),
                                              color: isSelected
                                                  ? const Color(0xff485908).withValues(alpha: .1)
                                                  : Colors.transparent,
                                            ),
                                            child: Center(
                                              child: Text(
                                                option,
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? const Color(0xff485908)
                                                      : const Color(0xff999999),
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                          ],

                          // Question 2: Types of user (from API)
                          if (controller.userTypeQuestion != null) ...[
                            Text(
                              controller.userTypeQuestion!['question'] ?? '',
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
                              () => Column(
                                children: [
                                  // User type options
                                  ...controller.userTypes.map((userType) {
                                    final isSelected = controller.selectedUserType.value == userType;
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.setUserType(userType);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 54.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xff485908)
                                                  : const Color(0xffE8E9E6),
                                              width: isSelected ? 3.w : 1.w,
                                            ),
                                            borderRadius: BorderRadius.circular(12.r),
                                            color: isSelected
                                                ? const Color(0xff485908).withValues(alpha: .1)
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Text(
                                              userType,
                                              style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? const Color(0xff485908)
                                                    : const Color(0xff999999),
                                                fontFamily: 'SFPro',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  
                                  // Other text field (shown when "Other" is selected)
                                  if (controller.showOtherTextField.value) ...[
                                    SizedBox(height: 8.h),
                                    Obx(
                                      () => Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller.hasOtherUserTypeText.value
                                                ? const Color(0xff485908)
                                                : const Color(0xffE8E9E6),
                                            width: controller.hasOtherUserTypeText.value ? 3.w : 1.w,
                                          ),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: TextField(
                                          controller: controller.otherUserTypeController,
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff172601),
                                            fontFamily: 'SFPro',
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Give the option type',
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
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],

                          // Question 3: Why are you using the app? (from API)
                      if (controller.whyUsingAppQuestion != null) ...[
                        Text(
                          controller.whyUsingAppQuestion!['question'] ?? '',
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
                          () => Column(
                            children: controller.whyUsingAppOptions.map((option) {
                              final isSelected = controller.selectedWhyUsingApp.value == option;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.setWhyUsingApp(option);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xff485908)
                                            : const Color(0xffE8E9E6),
                                        width: isSelected ? 3.w : 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: isSelected
                                          ? const Color(0xff485908).withValues(alpha: .1)
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? const Color(0xff485908)
                                            : const Color(0xff999999),
                                        fontFamily: 'SFPro',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

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
                );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
