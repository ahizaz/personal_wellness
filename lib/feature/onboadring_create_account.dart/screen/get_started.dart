import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/core/utils/constants/colors.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImagePath.gettingStarted),fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            Spacer(),
            Padding(padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Container(
               width: double.infinity,
               height: 56.h,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                color: AppColors.buttonColor,
               ),
               child: Center(child: Text('Get Started',style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xffFFFFFF)
               ),),),

            ),
            
            ),
            SizedBox(height: 40.h,),
          ],
        ),
      ),
      
    );
  }
}