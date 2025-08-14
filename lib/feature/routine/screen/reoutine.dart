
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

// class Routine extends StatelessWidget {
//   const Routine({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final RoutineController controller = Get.put(RoutineController());

//     return Scaffold(
//       backgroundColor: Color(0xffFFFFFF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 13.h),
//                 Center(
//                   child: Text(
//                     "Today",
//                     style: TextStyle(
//                       fontFamily: "SFPro",
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xff172601),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 25.h),
//                 Text(
//                   '${DateFormat('MMM d . EEEE').format(DateTime.now())}',
//                   style: TextStyle(
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xff172601),
//                     fontFamily: "SFPro",
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "All Day",
//                       style: TextStyle(
//                         fontFamily: "SFPro",
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                     SizedBox(width: 6.w),
                  
//                   Expanded(
//   child: Obx(() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: controller.routines.map((routine) {
//           return Container(
//             width: double.infinity,
//             margin: EdgeInsets.symmetric(vertical: 4.h),
//             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//             decoration: BoxDecoration(
//               color: routine.backgroundColor, // ✅ Controller থেকে আসা রঙ
//               borderRadius: BorderRadius.circular(6.r),
//             ),
//             child: Text(
//               routine.productName,
//               style: TextStyle(
//                 fontFamily: "SFPro",
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w400,
//                 color: Color(0xff3E4B2C),
//               ),
//             ),
//           );
//         }).toList(),
//       )),
// ),
// SizedBox(height: 16.h,),

//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class Routine extends StatelessWidget {
  const Routine({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineController controller = Get.put(RoutineController());///

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 13.h),
                Center(
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff172601),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                Text(
                  '${DateFormat('MMM d . EEEE').format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff172601),
                    fontFamily: "SFPro",
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "All Day",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.routines.map((routine) {
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: routine.backgroundColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  routine.productName,
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff3E4B2C),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Start modifications here
                Obx(() {
                  final now = TimeOfDay.now();
                  final currentTimeStr = '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.pm ? 'pm' : 'am'}';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (String time in [
                        '6:00 am', '7:00 am', '8:00 am', '9:00 am',
                        '10:00 am', '11:00 am', '12:00 pm', '1:00 pm',
                        '2:00 pm', '3:00 pm', '4:00 pm', '5:00 pm',
                        '6:00 pm', '7:00 pm', '8:00 pm', '9:00 pm',
                        '10:00 pm'
                      ])
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xff666666),
                                  ),
                                ),
                                if (time == '11:00 am') // Current time indicator
                                  Container(
                                    margin: EdgeInsets.only(left: 8.w),
                                    width: 2.w,
                                    height: 20.h,
                                    color: Colors.red,
                                  ),
                              ],
                            ),
                            if (controller.selectedTimes.contains(time) && controller.routines.isNotEmpty)
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: controller.routines[0].backgroundColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  controller.routines[0].productName,
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff3E4B2C),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}