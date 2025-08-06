import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';

class EmptyRoutineView extends StatelessWidget {
  const EmptyRoutineView({super.key});

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 30.h),
     child: Column(
    
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    SizedBox(height: 30.h,),
      Row(
        children: [
          Image.asset(IconPath.profileicon,height: 48.h,width: 48.w,fit: BoxFit.cover,),
          SizedBox(width: 16.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi there!",style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff3E4B2C)
              ),),
            
              Text("Good Morning",style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                   color: Color(0xff3E4B2C)
                
              ),)
            ],
          ),
          Spacer(),
          Image.asset(IconPath.notificationhome,height: 48.h,width: 48.w,fit: BoxFit.cover,),
          SizedBox(width: 5.w,),
          Image.asset(IconPath.search,height: 48.h,width: 48.w,fit: BoxFit.cover,)
          
        ],
      ),
      SizedBox(height: 16.h,),
      Text("Today",style: TextStyle(
        fontFamily: "SFPro",
        fontSize: 34.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xff172601)
      ),)
      ],
     ),
   );
  }
}