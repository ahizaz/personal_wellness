import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
               BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
          SafeArea(child: Center(
            child: SingleChildScrollView(
               padding: EdgeInsets.only(
                  top: 60.h, // এখানে top padding দেওয়া হয়েছে
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
                        Center(
                          child: Image(image: AssetImage(ImagePath.logout),
                          width: 48.w,height: 48.h,fit: BoxFit.cover,),
                        ),
                        SizedBox(height: 24.h,),
                        Center(
                          child: Text("Log out",style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff172601)

                          ),),
                        ),
                               SizedBox(height: 8.h,),
                               Center(
                          child: Text("Do you want to log out?",style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff3E4B2C)

                          ),),
                        ),
                        SizedBox(height: 53.h,),
                        Row(
                          children: [
                            Expanded(child: Container(
                              width: double.infinity,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: Color(0xffD94E2E),
                                borderRadius: BorderRadius.circular(999.r)
                              ),
                              child: Center(
                                child: Text("Yes,Log out",style:TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFFFFFF)
                                ),),
                              ),
                            )),
                            SizedBox(width: 8.w,),
                                  Expanded(child: InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Container(
                                                                  width: double.infinity,
                                                                  height: 48.h,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xffEDEEE6),
                                                                    borderRadius: BorderRadius.circular(999.r)
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("No, keep me loggin",style:TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff172601),
                                                                    ),),
                                                                  ),
                                                                ),
                                  ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ),
          ))
        ],
      ),
    );
  }
}