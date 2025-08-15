
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';
import 'package:personal_wellness/feature/routine/screen/view_routing_product.dart';

class Routine extends StatelessWidget {
  const Routine({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineController controller = Get.put(RoutineController());

    // Helper function to parse time strings like "7:15 pm" or "10.00 pm"
    DateTime? _parseRoutineTime(String timeStr) {
      // Normalize time string format
      final normalizedTime = timeStr.replaceAll('.', ':');
      try {
        final now = DateTime.now();
        final format = DateFormat('h:mm a');
        final parsedTime = format.parse(normalizedTime);
        // Return a DateTime object with today's date but the parsed time
        return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
      } catch (e) {
        // Return null if parsing fails
        return null;
      }
    }

    // Helper function to calculate the vertical position based on time
    double _calculateTopOffset(DateTime time, double hourHeight, int startHour) {
      final minutesFromTimelineStart = (time.hour * 60 + time.minute) - (startHour * 60);
      return (minutesFromTimelineStart / 60.0) * hourHeight;
    }

    const double hourHeight = 80.0; // Height for each hour slot
    const int startHour24 = 13; // Timeline starts at 1 PM
    const int endHour24 = 22; // Timeline ends at 10 PM
    final totalHours = endHour24 - startHour24 + 1;

    final now = DateTime.now();
    final currentTimeOffset = _calculateTopOffset(now, hourHeight, startHour24);

    return Scaffold(
     backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 13.h),
                const Center(
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff172601),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                Text(
                  DateFormat('MMM d . EEEE').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 17,
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
                    const Text(
                      "All Day",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.routines.map((routine) {
                              return InkWell(
                                onTap:(){
                              Get.to(()=>ViewRoutingProduct(productName:routine.productName));
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: routine.backgroundColor,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    routine.productName,
                                    style: const TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff3E4B2C),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // --- Start of new timeline implementation ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: Time labels (1 PM, 2 PM, etc.)
                    Padding(
                      padding: EdgeInsets.only(top: hourHeight / 2 - 10.h), // Adjust alignment
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(totalHours, (index) {
                          final hour = startHour24 + index;
                          return SizedBox(
                            height: hourHeight,
                            child: Text(
                              DateFormat('h a').format(DateTime(0, 0, 0, hour)),
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff757575),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Right side: Timeline with items and current time indicator
                    Expanded(
                      child: SizedBox(
                        height: totalHours * hourHeight,
                        child: Stack(
                          children: [
                            // Background horizontal lines
                            Column(
                              children: List.generate(totalHours, (index) {
                                return SizedBox(
                                  height: hourHeight,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 1,
                                      color: const Color(0xffE0E0E0),
                                    ),
                                  ),
                                );
                              }),
                            ),

                            // Scheduled Routine Items
                            Obx(
                              () => Stack(
                                children: controller.routines.map((routine) {
                                  final routineTime = _parseRoutineTime(routine.time);
                                  if (routineTime == null) {
                                    return const SizedBox.shrink();
                                  }
                                  final topOffset = _calculateTopOffset(routineTime, hourHeight, startHour24);

                                  // Check if the item is within the timeline's hour range
                                  if (routineTime.hour < startHour24 || routineTime.hour > endHour24) {
                                    return const SizedBox.shrink();
                                  }

                                  return Positioned(
                                    top: topOffset,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFFF2F2),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10.w,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.red, width: 1.5),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            routine.productName,
                                            style: TextStyle(
                                              fontFamily: "SFPro",
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff172601),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            // Current time indicator (if within timeline hours)
                            if (now.hour >= startHour24 && now.hour <= endHour24)
                              Positioned(
                                top: currentTimeOffset,
                                left: 0,
                                right: 0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('h:mm').format(now),
                                      style: TextStyle(
                                        fontFamily: "SFPro",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1.5,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // --- End of new timeline implementation ---
              ],
            ),
          ),
        ),
      ),
    );
  }
}