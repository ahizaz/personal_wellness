
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

    const double timeSlotHeight = 28.0; // Height with more spacing for 15-minute slot
    const double slotMargin = 30.0; // Consistent margin for spacing
    
    // Helper function to calculate the vertical position based on time (15-minute intervals)
    double _calculateTopOffset(DateTime time, double slotHeight, int startHour) {
      final minutesFromTimelineStart = (time.hour * 60 + time.minute) - (startHour * 60);
      return (minutesFromTimelineStart / 15.0) * (slotHeight + slotMargin / 4); // Fixed calculation with proper spacing
    }
    const int startHour24 = 0; // Timeline starts at 12 AM (midnight)
    const int endHour24 = 23; // Timeline ends at 11 PM (23:00) - full 24 hours
    const int minutesPerSlot = 15; // 15-minute intervals
    final totalHours = endHour24 - startHour24 + 1;
    final totalTimeSlots = totalHours * 4; // 4 slots per hour (15-minute intervals)

    final now = DateTime.now();
    final currentTimeOffset = _calculateTopOffset(now, timeSlotHeight, startHour24);
    
    // Debug: Print current time and calculated offset
    debugPrint('=== Current Time Debug ===');
    debugPrint('Current time: ${DateFormat('h:mm a').format(now)}');
    debugPrint('Current hour: ${now.hour}, minute: ${now.minute}');
    debugPrint('Calculated offset: $currentTimeOffset');

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
                SizedBox(
                 // Fixed height for scrollable timeline
                  child: SingleChildScrollView(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side: Time labels (12:00 AM, 12:15 AM, 12:30 AM, etc.)  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(totalTimeSlots, (index) {
                        final totalMinutes = (startHour24 * 60) + (index * minutesPerSlot);
                        final hour = (totalMinutes ~/ 60) % 24; // Ensure 24-hour format
                        final minute = totalMinutes % 60;
                        
                        // Show labels for 15-minute intervals with proper spacing
                        return Container(
                          height: timeSlotHeight + slotMargin / 4,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              DateFormat('h:mm a').format(DateTime(0, 0, 0, hour, minute)),
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff757575),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: 8.w),
                    // Right side: Timeline with items and current time indicator
                    Expanded(
                      child: SizedBox(
                        height: totalTimeSlots * (timeSlotHeight + slotMargin / 4), // Fixed height calculation
                        child: Stack(
                          children: [
                            // Background horizontal lines (every hour)
                            ...List.generate(totalHours, (hourIndex) {
                              // Calculate position for each hour line (after each full hour)
                              // Each hour has 4 time slots (15-minute intervals)
                              // Line should appear after every 4 slots
                              final lineTopPosition = (hourIndex + 1) * 4 * (timeSlotHeight + slotMargin / 4); // Fixed position calculation
                              return Positioned(
                                top: lineTopPosition,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2, // Make lines thicker to be more visible
                                  color: const Color(0xffD0D0D0), // Make lines darker to be more visible
                                ),
                              );
                            }),

                            // Scheduled Routine Items
                            Obx(
                              () {
                                if (controller.routines.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                // Use the first routine from already sorted list (closest to current time)
                                final closestRoutine = controller.routines.first;

                                // Debug: Print closest routine
                                debugPrint('=== Timeline Debug ===');
                                debugPrint('Total routines: ${controller.routines.length}');
                                debugPrint('Showing closest routine: ${closestRoutine.productName} at ${closestRoutine.time}');
                                debugPrint('All routines in order:');
                                for (int i = 0; i < controller.routines.length; i++) {
                                  final routine = controller.routines[i];
                                  debugPrint('${i + 1}. ${routine.productName} - ${routine.time}');
                                }
                                
                                // Show the closest routine (first in sorted list)

                                final routineTime = _parseRoutineTime(closestRoutine.time);
                                
                                if (routineTime == null || routineTime.hour < startHour24 || routineTime.hour > endHour24) {
                                  return const SizedBox.shrink();
                                }

                                final topOffset = _calculateTopOffset(routineTime, timeSlotHeight, startHour24);

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
                                      DateFormat('h:mm a').format(now), // Changed to include AM/PM for clarity
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
                  ),
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