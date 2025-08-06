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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
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
            Text(
              '${DateFormat('MMM d . EEEE').format(DateTime.now())}',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff3E4B2C),
              ),
            ),
            SizedBox(height: 16.h),
            // Observe the reactive routineData from controller
            Obx(() => Column(
                  children: controller.routineData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.h), // Space between containers
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h,),
                              Row(
                                children: [
                                  Image.asset(
                                    data['icon'],
                                    width: 20.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    data['title'],
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    data['time'],
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                             
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    child: Text(
                                      data['description'],
                                      style: TextStyle(
                                        fontFamily: "SFPro",
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      value: data['isCompleted'].value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.toggleCompletion(index, value);
                                        }
                                      },
                                      activeColor: Color(0xff485908),
                                      checkColor: Colors.white,
                                      shape: CircleBorder(),
                                      side: BorderSide(
                                          color: Color(0xffEDE9E6), width: 2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                SizedBox(height: 10.h,),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.r),
                    color: Color(0xff0E1701)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Today: 1/3 completed",style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffE8E9E6)
                        ),)
                      ],
                    ),
                  ),
                )

          ],
        ),
      ),
    );
  }
}