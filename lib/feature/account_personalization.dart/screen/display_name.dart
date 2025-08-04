import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class DisplayName extends StatelessWidget {
  const DisplayName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
           decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.accountBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
                  height: 412.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 33.h,),
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
                      SizedBox(height: 28.h,),
                      Center(
                        child: Text("Hi there",style: TextStyle(
                         fontFamily: 'SFPro',
                         fontSize: 28.sp,
                         fontWeight: FontWeight.w400,
                         color: Color(0xff172601)


                        ),),
                      ),
                      Text(" What should we call you ?",
                      style: TextStyle(
                         fontFamily: 'SFPro',
                         fontSize: 28.sp,
                         fontWeight: FontWeight.w400,
                         color: Color(0xff172601)


                        ),
                      ),


                    ],
                  ),
                  ),
            )

          ],
        ),
        ),
        
      ),
    ); 
  }
}