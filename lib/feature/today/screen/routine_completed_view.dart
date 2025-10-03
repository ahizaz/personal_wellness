import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class RoutineCompletedView extends StatelessWidget {
  const RoutineCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
           padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 30.h),
           child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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