import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/profile_accountseetings/controller/profile_account_controller.dart';
import 'package:personal_wellness/feature/profile_accountseetings/widget/custom_account_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AccountSeetings extends StatelessWidget {
  const AccountSeetings({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileAccountController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: .3)),
          ),

          // Main Form
          SafeArea(
            child: Center(
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
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Account settings',
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
                          "Personal information",
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
                          "Enter your details with valid information.",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff3E4B2C),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomProfileTextField(
                          controller: profileController.firstNameController,
                          isFocused: profileController.isFirstNameFocused,
                          hintText: "First Name",
                        ),
                        SizedBox(height: 12.h),
                        CustomProfileTextField(
                          controller: profileController.lastNameController,
                          isFocused: profileController.isLastNameFocused,
                          hintText: "Last Name",
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Date of Birth (Optional)",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff3E4B2C),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Obx(
                          () => Row(
                            children: [
                              // Month Dropdown
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 48.h,
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xffC4C4C4)),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      alignment: Alignment.centerLeft,
                                      dropdownColor: Colors.white,
                                    
                                      value: profileController.selectedMonth.value.isEmpty
                                          ? null
                                          : profileController.selectedMonth.value,
                                      hint: const Text("Month"),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      menuMaxHeight: 200,
                                      onChanged: (String? newValue) {
                                        profileController.selectedMonth.value = newValue ?? '';
                                      },
                                      items: [
                                        "January",
                                        "February",
                                        "March",
                                        "April",
                                        "May",
                                        "June",
                                        "July",
                                        "August",
                                        "September",
                                        "October",
                                        "November",
                                        "December"
                                      ].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 4.h),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),

                              // Date Input
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 48.h,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Date",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(color: Color(0xffC4C4C4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),

                              // Year Input
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 48.h,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Year",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(color: Color(0xffC4C4C4)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Obx(
                          () => CustomButton(
                            text: 'Save Changes',
                            color: const Color(0xff172601),
                            textStyle: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: 'SFPro',
                              fontWeight: FontWeight.w600,
                              color: profileController.isFormValid.value
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF999999),
                            ),
                            onTap: profileController.isFormValid.value
                                ? () {
                                    profileController.updateProfile();
                                  }
                                : (){},
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
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