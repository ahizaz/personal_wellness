
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/reminders/controller/notification_seetings_controller.dart';

class NotificationSeetings extends StatelessWidget {
  const NotificationSeetings({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationSeetingsController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withValues(alpha: .3)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 60.h,
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(32.r),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 25.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Reminders',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff172601),
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 36.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F5EE),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    IconPath.cross,
                                    width: 20.w,
                                    height: 20.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),

                        // Daily Reminder row (title + switch)
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Daily Reminder (AM/PM)',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff172601),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'Get a gentle nudge to start your routine.',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xff616161),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    // Time options (checkboxes)
                                    Opacity(
                                      opacity:
                                          controller.dailyReminder.value ? 1.0 : 0.5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Morning
                                          InkWell(
                                            onTap: controller.dailyReminder.value
                                                ? () => controller.toggleMorning(!controller.morning.value)
                                                : null,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: controller.morning.value,
                                                  onChanged: controller.dailyReminder.value
                                                      ? controller.toggleMorning
                                                      : null,
                                                  activeColor: const Color(0xff40541E),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  'Morning',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: const Color(0xff172601),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Evening
                                          InkWell(
                                            onTap: controller.dailyReminder.value
                                                ? () => controller.toggleEvening(!controller.evening.value)
                                                : null,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: controller.evening.value,
                                                  onChanged: controller.dailyReminder.value
                                                      ? controller.toggleEvening
                                                      : null,
                                                  activeColor: const Color(0xff40541E),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  'Evening',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: const Color(0xff172601),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Both
                                          InkWell(
                                            onTap: controller.dailyReminder.value
                                                ? () => controller.toggleBoth(!controller.both.value)
                                                : null,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: controller.both.value,
                                                  onChanged: controller.dailyReminder.value
                                                      ? controller.toggleBoth
                                                      : null,
                                                  activeColor: const Color(0xff40541E),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  'Both',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: const Color(0xff172601),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Switch on the right
                              Container(
                                margin: EdgeInsets.only(left: 12.w, top: 6.h),
                                child: Switch.adaptive(
                                  value: controller.dailyReminder.value,
                                  onChanged: controller.toggleDailyReminder,
                                  activeColor: const Color(0xff40541E),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),
                        Divider(height: 1, color: Colors.grey[300]),
                        SizedBox(height: 16.h),

                        // Routine Completion Reminder
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Routine Completion Reminder',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff172601),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'Stay on track and complete your skincare steps.',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: const Color(0xff616161),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w, top: 6.h),
                                child: Switch.adaptive(
                                  value: controller.routineReminder.value,
                                  onChanged: controller.toggleRoutineReminder,
                                  activeColor: const Color(0xff40541E),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // add more items below as needed...
                        SizedBox(height: 16.h),

                        // Done button — enabled only when both toggles are ON
                        Obx(
                          () {
                            final enabled = controller.isDoneEnabled;
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: enabled
                                    ? () {
                                        // Now call controller to fetch routines and show notifications
                                        controller.applySettingsAndShowNotifications(context);
                                      }
                                    : null,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                                      if (states.contains(MaterialState.disabled)) {
                                        return Colors.grey[300];
                                      }
                                      return const Color(0xff40541E);
                                    },
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(vertical: 14.h)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}