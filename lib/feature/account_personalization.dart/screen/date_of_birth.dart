import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/account_personalization.dart/screen/skin_type.dart';

class DateOfBirth extends StatelessWidget {
  const DateOfBirth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 33.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              IconPath.back,
                              height: 32.h,
                              width: 32.h,
                              fit: BoxFit.cover,
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
                      SizedBox(height: 34.h),
                      Center(
                        child: Text(
                          "What's your date of birth?",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff172601),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // === Cupertino Date Picker Start ===
                      SizedBox(
                        height: 215.h,
                        child: CupertinoDatePicker(
                         backgroundColor: Colors.transparent,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(2000, 1, 1),
                          minimumYear: 1970,
                           maximumYear: 2050,
                           
      
                          onDateTimeChanged: (DateTime newDate) {
                       
                          },
                        ),
                      ),
                      SizedBox(height: 24.h,),
                      Row(
                        children: [
                          Expanded(child: CustomButton(text: "Continue 2/5", color: Color(0xff172601), onTap: (){
                            Get.to(()=>SkinType());
                          })),
                          SizedBox(width: 12.w,),
                                Expanded(child: CustomButton(text: "Skip",
                                textStyle: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff121221),
                                  fontFamily: "SFPro"
                                ),
                                 color: Color(0xffEDEEE6), onTap: (){
                               Get.to(()=>SkinType());
                          })),
                          SizedBox(height: 24.h,)

                        ],
                      ),
                       SizedBox(height: 24.h,)
                   
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }
}
