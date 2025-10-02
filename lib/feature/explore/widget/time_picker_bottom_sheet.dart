import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class TimePickerBottomSheet extends StatelessWidget {
  final bool isEvening;
  
  const TimePickerBottomSheet({super.key, this.isEvening = false});

  @override
  Widget build(BuildContext context) {
    final RoutineController controller = Get.find<RoutineController>();
    
    // Local variables to track the selected values
    int selectedHour = 1;
    int selectedMinute = 0;
    String selectedAmPm = "AM";

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
            Text(
              "Choose a time when you want to start using the\nproduct",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff78816C),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        selectedHour = index + 1;
                      },
                      children: List.generate(
                        12,
                        (i) => Center(
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Minute picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        selectedMinute = index;
                      },
                      children: List.generate(
                        60,
                        (i) => Center(
                          child: Text(
                            i.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // AM/PM picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        selectedAmPm = index == 0 ? "AM" : "PM";
                      },
                      children: [
                        Center(
                          child: Text(
                            "AM",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "PM",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
                // Format the selected time
                String formattedTime = "$selectedHour:${selectedMinute.toString().padLeft(2, '0')} ${selectedAmPm.toLowerCase()}";
                
                // Add to appropriate time list
                if (isEvening) {
                  controller.toggleEveningTimeSelection(formattedTime);
                } else {
                  controller.toggleTimeSelection(formattedTime);
                }
                
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