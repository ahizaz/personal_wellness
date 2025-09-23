import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class DatePickerHelper {
  static void showDateBottomSheet({
    required BuildContext context,
    required bool isStart,
    required GlobalKey key,
    required RoutineController controller,
  }) {
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
            top: position.dy + fieldSize.height + 4.h,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isStart ? 'Start date' : 'End date',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff172601),
                              fontFamily: 'SFPro',
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'DD/MM/YY',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff172601),
                                  fontFamily: 'SFPro',
                                ),
                              ),
                              SizedBox(width: 8.w),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    TableCalendar(
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2100),
                      focusedDay: isStart
                          ? (controller.startDate.value ?? DateTime.now())
                          : (controller.endDate.value ?? DateTime.now()),
                      selectedDayPredicate: (day) {
                        if (isStart) {
                          return isSameDay(controller.startDate.value, day);
                        } else {
                          return isSameDay(controller.endDate.value, day);
                        }
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (isStart) {
                          controller.startDate.value = selectedDay;
                          controller.startFocused.value = false;
                        } else {
                          controller.endDate.value = selectedDay;
                          controller.endFocused.value = false;
                        }
                        entry?.remove();
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: const Color(0xff485908),
                          shape: BoxShape.circle,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        todayBuilder: (context, day, focusedDay) {
                          return Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: const Color(0xff172601),
                                fontWeight: FontWeight.w400,
                                fontSize: 28,
                              ),
                            ),
                          );
                        },
                      ),
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
}