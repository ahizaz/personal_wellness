import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class TimePickerBottomSheet extends StatelessWidget {
  const TimePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineController controller = Get.find<RoutineController>();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Time",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xff172601),
              ),
            ),
            SizedBox(height: 16.h),
              Text("Choose a time when you want to start using the\nproduct",style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff78816C),
              ),
              textAlign: TextAlign.center,
              ),
            SizedBox(
              height: 200.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedMinute.value - 1,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        controller.selectedSecond.value = index + 1;
                      },
                      children: List.generate(
                        12,
                        (i) => Center(
                          child: Text((i + 1).toString()),
                        ),
                      ),
                    ),
                  ),
                  // Minute picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedMinute.value,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        controller.selectedMinute.value = index;
                      },
                      children: List.generate(
                        60,
                        (i) => Center(
                          child: Text(i.toString().padLeft(2, '0')),
                        ),
                      ),
                    ),
                  ),
                  // AM/PM picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedAmPm.value == "AM" ? 0 : 1,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        controller.selectedAmPm.value =
                            index == 0 ? "AM" : "PM";
                      },
                      children: const [
                        Center(child: Text("AM")),
                        Center(child: Text("PM")),
                      ],
                    ),
                  ),
                ],
              ),
            ),

           
            Divider(
              color: Color(0xffE8E9E6),
              thickness: 2.h,
            ),
             SizedBox(height: 16.h),

            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xff172601),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: const Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

}