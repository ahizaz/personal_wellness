import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';

class RoutineCompletedView extends StatelessWidget {
  const RoutineCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    final TodayController controller = Get.find<TodayController>();
    
    return Padding(
           padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 30.h),
           child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h,),
                Row(
              children: [
                InkWell(
                  onTap: () {
                
                  },
                  child: Obx(() {
                    final imagePath = controller.profileImagePath.value;
                    return CircleAvatar(
                      radius: 24.r,
                      backgroundImage: imagePath.isNotEmpty
                          ? FileImage(File(imagePath)) as ImageProvider
                          : AssetImage(IconPath.profileicon),
                    );
                  }),
                ),
                SizedBox(width: 16.w),
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi ${controller.userName.value}!",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff3E4B2C),
                          ),
                        ),
                        Text(
                          "Good Morning",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff3E4B2C),
                          ),
                        ),
                      ],
                    )),
                const Spacer(),
                Image.asset(IconPath.notificationhome,
                    height: 48.h, width: 48.w, fit: BoxFit.cover),
                SizedBox(width: 5.w),
                Image.asset(IconPath.search,
                    height: 48.h, width: 48.w, fit: BoxFit.cover),
              ],
            ),
              SizedBox(height: 16.h),
               Text(
              "Today",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 34.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff172601),
              ),
            ),
                SizedBox(height: 40.h,),
                  Center(child: Image.asset(ImagePath.completed,width: 162.w,height: 164.h,fit: BoxFit.cover,),),
                  SizedBox(height: 40.h,),
                       Center(child: Text("Congratulation",textAlign: TextAlign.center,style: TextStyle(
        fontFamily: "SFPro",
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xff172601)
      ),)),
      Center(
        child: Text("You’ve completed all your skincare steps today.",
        textAlign: TextAlign.center,
        style: TextStyle(
           fontFamily: "SFPro",
           fontWeight: FontWeight.w400,
           color: Color(0xff3E4B2C)
        ),),
      )
                  
              ],
           ),
    );
  }
}