import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class NotificationsPerson extends StatelessWidget {
  const NotificationsPerson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.infinity,
        height: double.infinity,
           decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.accountBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 408.h,
                  decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(padding:  EdgeInsets.symmetric(horizontal: 20.w),
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
                      Center(
                        child: Image(image: AssetImage(ImagePath.notification,),width: 64.w,height: 56.h,fit: BoxFit.cover,),
                      ),
                      SizedBox(height: 29.h,),
                      Center(
                        child: Text("Turn on notifications?",style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "SFPro",
                          color: Color(0xff172601)
                        ),),
                      ),
                      SizedBox(height: 16.h,),
                      Text("     Allow notifications to be the first to\n  discover exclusive perks and benefits\n                  for the community",style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff78816C)
                      ),)


                  ],
                ),
                
                ),

            )
          ],
        ),),

            ),
    );
  }
}