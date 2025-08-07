import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h)
            ,
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(onTap: (){
                      Get.back();
                    },child: Image.asset(IconPath.backarrow,width: 24.w,height: 24.h,fit: BoxFit.cover,)),
                    SizedBox(width: 120.w,),
                    Center(
                      child: Text("Product",style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000)
                      ),),
                    )
                  ],
                ),
                SizedBox(height: 9.h,),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}