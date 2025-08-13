// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:personal_wellness/core/utils/constants/image_path.dart';
// import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';
// import 'package:personal_wellness/feature/explore/screen/add_to_routine.dart';
// import 'package:personal_wellness/feature/explore/widget/howtoUseit.dart';
// import 'package:personal_wellness/feature/today/widget/product_header.dart';

// class ViewProduct extends StatelessWidget {
//   const ViewProduct({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ViewProductController controller = Get.put(ViewProductController());
//     return Scaffold(
//        backgroundColor: const Color(0xffEDEEE6),
//        body:SafeArea(child: SingleChildScrollView(
//         child: Padding(padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                   ProductHeader(title: 'Product',),
//                   SizedBox(height: 9.h),
//                  Stack(
//   alignment: Alignment.center,
//   children: [
//     // Reactive image container
//     Obx(() => Container(
//           width: double.infinity,
//           height: 298.h,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                   controller.imagePath[controller.currentIndex.value]),
//               fit: BoxFit.cover,
//             ),
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(bottom: 12.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 28.w,
//                       height: 2.h,
//                       color: controller.currentIndex.value >= 0
//                           ? Color(0xffFFFFFF)
//                           : Color(0xffEDEEE6),
//                     ),
//                     SizedBox(width: 8.w),
//                     Container(
//                       width: 28.w,
//                       height: 2.h,
//                       color: controller.currentIndex.value >= 1
//                           ? Color(0xffFFFFFF)
//                           : Color(0xffEDEEE6),
//                     ),
//                     SizedBox(width: 8.w),
//                     Container(
//                       width: 28.w,
//                       height: 2.h,
//                       color: controller.currentIndex.value >= 2
//                           ? Color(0xffFFFFFF)
//                           : Color(0xffEDEEE6),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )),

//     // Left arrow - only show if not on first image
//     Obx(() => controller.currentIndex.value > 0
//         ? Positioned(
//             left: 16.w,
//             child: InkWell(
//               onTap: controller.prevImage,
//               child: Container(
//                 width: 32.w,
//                 height: 182.h,
//                 decoration: BoxDecoration(
//                   color: Color(0xffFFFFFF).withValues(alpha: 0.4),
//                   borderRadius: BorderRadius.circular(11.r),
//                 ),
//                 child: Icon(
//                   Icons.arrow_back_ios,
//                   size: 20.r,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           )
//         : SizedBox()),

//     // Right arrow - only show if not on last image
//     Obx(() => controller.currentIndex.value < controller.imagePath.length - 1
//         ? Positioned(
//             right: 16.w,
//             child: InkWell(
//               onTap: controller.nextImage,
//               child: Container(
//                 width: 32.w,
//                 height: 182.h,
//                 decoration: BoxDecoration(
//                   color: Color(0xffFFFFFF).withValues(alpha: 0.4),
//                   borderRadius: BorderRadius.circular(11.r),
//                 ),
//                 child: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 20.r,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           )
//         : SizedBox()),
//   ],
// ),

//         SizedBox(height: 16.h,),
//               Text(
//                   controller. productDataview["productName"],
//                   style: TextStyle(
//                     fontFamily: "SFPro",
//                     fontSize: 28.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xff172601),
//                   ),
//                 ),
//                    SizedBox(height: 16.h),
//                      Text(
//                   "Ingredients",
//                   style: TextStyle(
//                     fontFamily: "SFPro",
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xff172601),
//                   ),
//                 ),
//                  SizedBox(height: 4.h),
//                  Text(
//                   controller.productDataview["ingredients"],
//                   style: TextStyle(
//                     fontFamily: "SFPro",
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xff3E4B2C),
//                   ),
//                 ),
//                 SizedBox(height: 16.h,),
//                 Howtouseit(),
//                 SizedBox(height: 24.h,),
//                 InkWell(
//                   onTap: (){
//                     Get.to(AddToRoutine());
//                   },
//                   child: Container(
//                    width: double.infinity,
//                    height: 48.h,
//                    decoration: BoxDecoration(
//                     color: Color(0xff172601),
//                     borderRadius: BorderRadius.circular(999.r),
//                    ),
//                    child: Center(
//                     child: Text("+   Add to my routine",style: TextStyle(
//                       fontFamily: "SFPro",
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xffFFFFFF)
//                     ),),
//                    ),
//                   ),
//                 ),
//                 SizedBox(height: 24.h,),
//                 Text("Relevant products",style: TextStyle(
//                   fontFamily: "SFPro",
//                   fontSize: 28.sp,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xff172601)
//                 ),),
                
//                      SizedBox(height: 16.h,),
//                         Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset(ImagePath.product4,width: 177.w,height: 182.h,fit: BoxFit.cover,),
//                         SizedBox(height: 8.h,),
//                         Text("The Ordinary Anti-\naging Serum",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
//                       ],
//                     ),
//                       SizedBox(width: 16.w,),
//                          Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset(ImagePath.product3,width: 177.w,height: 182.h,fit: BoxFit.cover,),
//                         SizedBox(height: 8.h,),
//                         Text("Whitening Night\nCream",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
//                       ],
//                     ),

//                   ],
//                 ),
//                     SizedBox(height: 16.h,),
//                         Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset(ImagePath.product2,width: 177.w,height: 182.h,fit: BoxFit.cover,),
//                         SizedBox(height: 8.h,),
//                         Text("Vitamin C Serum\n50g",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
//                       ],
//                     ),
//                       SizedBox(width: 16.w,),
//                          Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset(ImagePath.product1,width: 177.w,height: 182.h,fit: BoxFit.cover,),
//                         SizedBox(height: 8.h,),
//                         Text("Essence Sun’s\nCream SPF45 ",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
//                       ],
//                     ),

//                   ],
//                 ),
//                     SizedBox(height: 14.h,),
                    
   

//               ],
//         ),
//         ),
//        )),

//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';
import 'package:personal_wellness/feature/explore/screen/add_to_routine.dart';
import 'package:personal_wellness/feature/explore/widget/howtoUseit.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewProductController controller = Get.put(ViewProductController());
    // Override product name with passed argument if available
    final String? passedTitle = Get.arguments as String?;
    if (passedTitle != null) {
      controller.productDataview['productName'] = passedTitle;
    }
    return Scaffold(
       backgroundColor: const Color(0xffEDEEE6),
       body:SafeArea(child: SingleChildScrollView(
        child: Padding(padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  ProductHeader(title: 'Product',),
                  SizedBox(height: 9.h),
                 Stack(
  alignment: Alignment.center,
  children: [
    // Reactive image container
    Obx(() => Container(
          width: double.infinity,
          height: 298.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  controller.imagePath[controller.currentIndex.value]),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28.w,
                      height: 2.h,
                      color: controller.currentIndex.value >= 0
                          ? Color(0xffFFFFFF)
                          : Color(0xffEDEEE6),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 28.w,
                      height: 2.h,
                      color: controller.currentIndex.value >= 1
                          ? Color(0xffFFFFFF)
                          : Color(0xffEDEEE6),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 28.w,
                      height: 2.h,
                      color: controller.currentIndex.value >= 2
                          ? Color(0xffFFFFFF)
                          : Color(0xffEDEEE6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),

    // Left arrow - only show if not on first image
    Obx(() => controller.currentIndex.value > 0
        ? Positioned(
            left: 16.w,
            child: InkWell(
              onTap: controller.prevImage,
              child: Container(
                width: 32.w,
                height: 182.h,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.r,
                  color: Colors.black,
                ),
              ),
            ),
          )
        : SizedBox()),

    // Right arrow - only show if not on last image
    Obx(() => controller.currentIndex.value < controller.imagePath.length - 1
        ? Positioned(
            right: 16.w,
            child: InkWell(
              onTap: controller.nextImage,
              child: Container(
                width: 32.w,
                height: 182.h,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.r,
                  color: Colors.black,
                ),
              ),
            ),
          )
        : SizedBox()),
  ],
),

        SizedBox(height: 16.h,),
              Text(
                  controller.productDataview["productName"],
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff172601),
                  ),
                ),
                   SizedBox(height: 16.h),
                     Text(
                  "Ingredients",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                 SizedBox(height: 4.h),
                 Text(
                  controller.productDataview["ingredients"],
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3E4B2C),
                  ),
                ),
                SizedBox(height: 16.h,),
                Howtouseit(),
                SizedBox(height: 24.h,),
                InkWell(
                  onTap: (){
                    Get.to(AddToRoutine());
                  },
                  child: Container(
                   width: double.infinity,
                   height: 48.h,
                   decoration: BoxDecoration(
                    color: Color(0xff172601),
                    borderRadius: BorderRadius.circular(999.r),
                   ),
                   child: Center(
                    child: Text("+   Add to my routine",style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF)
                    ),),
                   ),
                  ),
                ),
                SizedBox(height: 24.h,),
                Text("Relevant products",style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff172601)
                ),),
                
                     SizedBox(height: 16.h,),
                        Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product4,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("The Ordinary Anti-\naging Serum",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),
                      SizedBox(width: 16.w,),
                         Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product3,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("Whitening Night\nCream",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),

                  ],
                ),
                    SizedBox(height: 16.h,),
                        Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product2,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("Vitamin C Serum\n50g",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),
                      SizedBox(width: 16.w,),
                         Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product1,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("Essence Sun’s\nCream SPF45 ",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),

                  ],
                ),
                    SizedBox(height: 14.h,),
                    
   

              ],
        ),
        ),
       )),

    );
  }
}