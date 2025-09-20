// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';


// class Howtouseit extends StatelessWidget {
//   const Howtouseit({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ViewProductController controller = Get.find<ViewProductController>();

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.r),
//         color: const Color(0xffFFFFFF),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "How to use",
//               style: TextStyle(
//                 fontFamily: "SFPro",
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xff172601),
//               ),
//             ),
//             SizedBox(height: 12.h),
//             Obx(() => Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: controller.howToUseIt.map<Widget>((item) {
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: 8.h),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: 8.h),
//                             child: Container(
//                               width: 6.w,
//                               height: 6.h,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xff78816C),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 12.w),
//                           Expanded(
//                             child: Text(
//                               item,
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: const Color(0xff3E4B2C),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';

class Howtouseit extends StatelessWidget {
  const Howtouseit({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewProductController controller = Get.find<ViewProductController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: const Color(0xffFFFFFF),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How to use",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff172601),
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.howToUseIt.map<Widget>((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff78816C),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff3E4B2C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )),
          ],
        ),
      ),
    );
  }
}