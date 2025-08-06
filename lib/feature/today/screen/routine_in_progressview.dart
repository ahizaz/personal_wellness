import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';

class RoutineInProgressview extends StatelessWidget {
  const RoutineInProgressview({super.key});

  @override
  Widget build(BuildContext context) {
    final TodayController controller = Get.find<TodayController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // Future use: image select page navigation
                  // Example: Get.to(ProfileUpdatePage());
                },
                child: Obx(() {
                  final imagePath = controller.profileImagePath.value;
                  return CircleAvatar(
                    radius: 24.r,
                    backgroundImage: imagePath.isNotEmpty
                        ? FileImage(
                            File(imagePath),
                          ) as ImageProvider
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
                          Text("Good Morning",style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                   color: Color(0xff3E4B2C)
                
              ),),
              

                    ],
                  )),
                    Spacer(),
          Image.asset(IconPath.notificationhome,height: 48.h,width: 48.w,fit: BoxFit.cover,),
          SizedBox(width: 5.w,),
          Image.asset(IconPath.search,height: 48.h,width: 48.w,fit: BoxFit.cover,),
            ],
          ),
          SizedBox(height: 16.h,),
             Text("Today",style: TextStyle(
        fontFamily: "SFPro",
        fontSize: 34.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xff172601)
      ),),
      Text(
             '${DateFormat('MMM d . EEEE').format(DateTime.now())}',
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w400,color: Color(0xff3E4B2C)),
        ),
        SizedBox(height: 16.h,),
        Container(
          width: double.infinity,
          height: 74.h,
          decoration: BoxDecoration(
            color: Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(12.r)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
           
              )
            ],
          ),
        )

             
        ],
      ),
    );
  }
}
