// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:intl/intl.dart';
// import 'package:personal_wellness/core/utils/constants/icon_path.dart';
// import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';
// import 'package:personal_wellness/feature/explore/widget/category_bottom_sheet.dart';
// import 'package:personal_wellness/feature/explore/widget/category_icon.dart';

// class AddToRoutine extends StatelessWidget {
//   AddToRoutine({super.key});

//   final RoutineController controller = Get.put(RoutineController());

//   void _showCategoryBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return const CategoryBottomSheet();
//       },
//     );
//   }

//   void _showDateBottomSheet(BuildContext context, bool isStart) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                      SizedBox(width: 16.w),
//                      Expanded(
//                       child: Center(
//                         child: Text(
//                           'Select date',
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xff172601),
//                             fontFamily: 'SFPro',
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(Icons.close, color: Color(0xff172601)),
//                     ),
//                      SizedBox(width: 16.w),
//                   ],
//                 ),
//                 CalendarDatePicker(
//                   initialDate: isStart
//                       ? controller.startDate.value ?? DateTime.now()
//                       : controller.endDate.value ?? DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                   onDateChanged: (date) {
//                     if (isStart) {
//                       controller.startDate.value = date;
//                     } else {
//                       controller.endDate.value = date;
//                     }
//                     Navigator.pop(context);
//                   },
//                 ),
//                 SizedBox(height: 16.h),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffFFFFFF),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                     const Expanded(
//                       child: Center(
//                         child: Text(
//                           'Add to my routine',
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xff172601),
//                             fontFamily: 'SFPro',
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Image.asset(
//                         IconPath.cross,
//                         width: 32.w,
//                         height: 32.h,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 26.h),
//                 const Text(
//                   "Product Type",
//                   style: TextStyle(
//                     fontFamily: "SFPro",
//                     fontSize: 17,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xff172601),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 InkWell(
//                   onTap: () {
//                     _showCategoryBottomSheet(context);
//                   },
//                   child: Row(
//                     children: [
//                       SizedBox(width: 12.w),
//                       const Text(
//                         "Choose Category",
//                         style: TextStyle(
//                           fontFamily: "SFPro",
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xff172601),
//                         ),
//                       ),
//                       const Spacer(),
//                       Image.asset(
//                         IconPath.rightarrow,
//                         width: 24.w,
//                         height: 24.h,
//                         fit: BoxFit.cover,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Obx(() {
//                   if (controller.selectedCategory.value.isNotEmpty) {
//                     return Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CategoryIcon(category: controller.selectedCategory.value),
//                           SizedBox(width: 8.w),
//                           Text(
//                             controller.selectedCategory.value,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff172601),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 }),
//                 SizedBox(height: 24.h,),
//                 Text("Schedule",style: TextStyle(fontFamily: "SFPro",
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff172601)
//                 ),),
//                 SizedBox(height: 8.h),
//                 GestureDetector(
//                   onTap: () {
//                     _showDateBottomSheet(context, true);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today_outlined,
//                           size: 24.sp,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(width: 8.w),
//                         Obx(
//                           () => Text(
//                             controller.startDate.value == null
//                                 ? 'Start date'
//                                 : DateFormat('dd/MM/yy').format(controller.startDate.value!),
//                             style: TextStyle(
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w500,
//                               color: controller.startDate.value == null
//                                   ? Colors.grey
//                                   : const Color(0xff172601),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 GestureDetector(
//                   onTap: () {
//                     _showDateBottomSheet(context, false);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today_outlined,
//                           size: 24.sp,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(width: 8.w),
//                         Obx(
//                           () => Text(
//                             controller.endDate.value == null
//                                 ? 'End date'
//                                 : DateFormat('dd/MM/yy').format(controller.endDate.value!),
//                             style: TextStyle(
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w500,
//                               color: controller.endDate.value == null
//                                   ? Colors.grey
//                                   : const Color(0xff172601),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
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
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';
import 'package:personal_wellness/feature/explore/widget/category_bottom_sheet.dart';
import 'package:personal_wellness/feature/explore/widget/category_icon.dart';

class AddToRoutine extends StatelessWidget {
  AddToRoutine({super.key});

  final RoutineController controller = Get.put(RoutineController());
  final GlobalKey startKey = GlobalKey();
  final GlobalKey endKey = GlobalKey();

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CategoryBottomSheet();
      },
    );
  }

  void _showDateBottomSheet(BuildContext context, bool isStart) {
    final key = isStart ? startKey : endKey;
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final fieldSize = renderBox.size;

    if (isStart) {
      controller.startFocused.value = true;
    } else {
      controller.endFocused.value = true;
    }

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (isStart) {
                  controller.startFocused.value = false;
                } else {
                  controller.endFocused.value = false;
                }
                entry?.remove();
              },
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + fieldSize.height,
            width: fieldSize.width,
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Center(
                            child: Text(
                              isStart ? 'Start date' : 'End date',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff172601),
                                fontFamily: 'SFPro',
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isStart) {
                              controller.startFocused.value = false;
                            } else {
                              controller.endFocused.value = false;
                            }
                            entry?.remove();
                          },
                          child: const Icon(Icons.close, color: Color(0xff172601)),
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),
                    CalendarDatePicker(
                      initialDate: isStart
                          ? controller.startDate.value ?? DateTime.now()
                          : controller.endDate.value ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      onDateChanged: (date) {
                        if (isStart) {
                          controller.startDate.value = date;
                        } else {
                          controller.endDate.value = date;
                        }
                        if (isStart) {
                          controller.startFocused.value = false;
                        } else {
                          controller.endFocused.value = false;
                        }
                        entry?.remove();
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add to my routine',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff172601),
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                    ),
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
                SizedBox(height: 26.h),
                const Text(
                  "Product Type",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    _showCategoryBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Text(
                        "Choose Category",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff172601),
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        IconPath.rightarrow,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  if (controller.selectedCategory.value.isNotEmpty) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryIcon(category: controller.selectedCategory.value),
                          SizedBox(width: 8.w),
                          Text(
                            controller.selectedCategory.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                SizedBox(height: 24.h,),
                Text("Schedule",style: TextStyle(fontFamily: "SFPro",
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff172601)
                ),),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    _showDateBottomSheet(context, true);
                  },
                  child: Obx(
                    () => Container(
                      key: startKey,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: controller.startFocused.value ? const Color(0xff172601) : Colors.grey[300]!,
                          width: controller.startFocused.value ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 24.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.startDate.value == null
                                ? 'Start date'
                                : DateFormat('dd/MM/yy').format(controller.startDate.value!),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: controller.startDate.value == null
                                  ? Colors.grey
                                  : const Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    _showDateBottomSheet(context, false);
                  },
                  child: Obx(
                    () => Container(
                      key: endKey,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: controller.endFocused.value ? const Color(0xff172601) : Colors.grey[300]!,
                          width: controller.endFocused.value ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 24.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.endDate.value == null
                                ? 'End date'
                                : DateFormat('dd/MM/yy').format(controller.endDate.value!),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: controller.endDate.value == null
                                  ? Colors.grey
                                  : const Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}