import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/explore/controller/explore_controller.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class SkinCondition extends StatelessWidget {
  final String imagePath;
  final String title;

  const SkinCondition({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final exploreController = Get.find<ExploreController>();

    return Scaffold(
      backgroundColor: const Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductHeader(title: 'Skin conditions'),
                SizedBox(height: 9.h),
                SizedBox(
                  width: double.infinity,
                  height: 298.h,
                  child: Image(image: AssetImage(imagePath), fit: BoxFit.cover),
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff000000),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Symptoms",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff172601),
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(() => Text(
                      exploreController.skinDetails["symptoms"],
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff3E4B2C),
                      ),
                    )),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Treatment",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff172601),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(() => Column(
                              children: List.generate(
                                (exploreController.skinDetails["treatments"]
                                        as List)
                                    .length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 9),
                                        child: Container(
                                          width: 6.w,
                                          height: 6.h,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff78816C),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 18.w),
                                      Expanded(
                                        child: Text(
                                          exploreController
                                                  .skinDetails["treatments"]
                                              [index],
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff3E4B2C),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                         
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h,),
                Text("Recommended products",style: TextStyle(fontFamily: "SFPro",fontSize: 28.sp,fontWeight: FontWeight.w400,color: Color(0xff172601)),),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     SizedBox(
                      width: 177.w,
                      height: 182.h,
                      child: Image.asset(ImagePath.product2,fit: BoxFit.cover,),
                      
                     ),
                     SizedBox(height: 8.h,),
                     Text("Vitamin C Serum\n50g",style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000)
                     ),)
                    ],
                  ),
                  SizedBox(width: 16.w,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     SizedBox(
                      width: 177.w,
                      height: 182.h,
                      child: Image.asset(ImagePath.product1,fit: BoxFit.cover,),
                      
                     ),
                     SizedBox(height: 8.h,),
                     Text("Essence Sun’s\nCream SPF45",style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000)
                     ),)
                    ],
                  ),
                  
                  ],
                ),
   
                 
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}