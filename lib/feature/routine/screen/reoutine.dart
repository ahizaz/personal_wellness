
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
      String normalizedTime = timeStr.replaceAll('.', ':').trim();
      
      // Ensure proper AM/PM formatting
      if (!normalizedTime.toLowerCase().contains('am') && !normalizedTime.toLowerCase().contains('pm')) {
        normalizedTime += ' am'; // Default to AM if no period specified
      }
      
      try {
        final now = DateTime.now();
        // Convert to uppercase for proper parsing since DateFormat expects uppercase AM/PM
        String upperTime = normalizedTime.toUpperCase();
        
        // Use 'a' for single character (A/P) or 'aa' for full form (AM/PM)
        DateFormat format;
        if (upperTime.endsWith('AM') || upperTime.endsWith('PM')) {
          format = DateFormat('h:mm aa'); // For "6:30 AM" or "6:30 PM"
        } else {
          format = DateFormat('h:mm a'); // For "6:30 A" or "6:30 P"
        }
        final parsedTime = format.parse(upperTime);
        // Return a DateTime object with today's date but the parsed time
        return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
      } catch (e) {
        // Try alternative formats
        try {
          String upperTime = normalizedTime.toUpperCase();
          DateFormat alternativeFormat;
          if (upperTime.endsWith('AM') || upperTime.endsWith('PM')) {
            alternativeFormat = DateFormat('h:m aa'); // For "6:3 AM" format
          } else {
            alternativeFormat = DateFormat('h:m a'); // For "6:3 A" format
          }
          final parsedTime = alternativeFormat.parse(upperTime);
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
        } catch (e) {
          debugPrint('Failed to parse time: $timeStr, normalized: $normalizedTime, error: $e');
          return null;
        }
      }
    }

    // Helper function to calculate the vertical position based on time
    double _calculateTopOffset(DateTime time, double hourHeight, int startHour) {
      final minutesFromTimelineStart = (time.hour * 60 + time.minute) - (startHour * 60);
      return (minutesFromTimelineStart / 60.0) * hourHeight;
    }

    const double hourHeight = 80.0; // Height for each hour slot
    const int startHour24 = 0; // Timeline starts at 12 AM (midnight)
    const int endHour24 = 23; // Timeline ends at 11 PM (23:00)
    final totalHours = endHour24 - startHour24 + 1;

    final now = DateTime.now();
    final currentTimeOffset = _calculateTopOffset(now, hourHeight, startHour24);

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingRoutines.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xff485908),
              ),
            );
          }
          return RefreshIndicator(
            color: Color(0xff485908),
            onRefresh: () async {
              await controller.refreshRoutines();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.allDayRoutines.map((routine) {
                            return InkWell(
                              onTap: () {
                                Get.to(() => ViewRoutingProduct(
                                  productName: routine.productName, 
                                  productId: routine.productId,
                                  startDate: routine.startDate,
                                  endDate: routine.endDate,
                                ));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 2.h), // less gap
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: routine.backgroundColor,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Optional dot/icon
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: EdgeInsets.only(right: 4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        routine.productName,
                                        style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontSize: 13.sp, // slightly smaller
                                          fontWeight: FontWeight.w400, // better readability
                                          color: Color(0xff3E4B2C),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // --- Start of new timeline implementation ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: Time labels (6 AM, 7 AM, etc.)
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
                                fontSize: 12.sp, // Smaller text for more hours
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
                              () {
                                if (controller.routines.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                // Find the routine with the closest time to current time
                                final currentTime = DateTime.now();
                                var closestRoutine;
                                int smallestTimeDifference = 999999;

                                for (var routine in controller.routines) {
                                  final routineTime = _parseRoutineTime(routine.time);
                                  if (routineTime != null) {
                                    final timeDifference = routineTime.difference(currentTime).inMinutes.abs();
                                    if (timeDifference < smallestTimeDifference) {
                                      smallestTimeDifference = timeDifference;
                                      closestRoutine = routine;
                                    }
                                  }
                                }

                                // Debug: Print closest routine
                                if (closestRoutine != null) {
                                  debugPrint('=== Timeline Debug ===');
                                  debugPrint('Total routines: ${controller.routines.length}');
                                  debugPrint('Closest routine: ${closestRoutine.productName} at ${closestRoutine.time}');
                                  debugPrint('Time difference: $smallestTimeDifference minutes');
                                }
                                
                                // Show only the closest routine
                                if (closestRoutine == null) {
                                  return const SizedBox.shrink();
                                }

                                final routineTime = _parseRoutineTime(closestRoutine.time);
                                
                                if (routineTime == null || routineTime.hour < startHour24 || routineTime.hour > endHour24) {
                                  return const SizedBox.shrink();
                                }

                                final topOffset = _calculateTopOffset(routineTime, hourHeight, startHour24);

                                return Stack(
                                  children: [
                                    Positioned(
                                      top: topOffset,
                                      left: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          // Navigate to product detail page
                                          Get.to(() => ViewRoutingProduct(
                                            productName: closestRoutine.productName, 
                                            productId: closestRoutine.productId,
                                            startDate: closestRoutine.startDate,
                                            endDate: closestRoutine.endDate,
                                          ));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1), // Red background for closest routine
                                            borderRadius: BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10.w,
                                                height: 10.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  closestRoutine.productName,
                                                  style: TextStyle(
                                                    fontFamily: "SFPro",
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff172601),
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                closestRoutine.time,
                                                style: TextStyle(
                                                  fontFamily: "SFPro",
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
          )
          );
        }
      )
      )
    );
  }
}