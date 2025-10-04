import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/explore/screen/explore.dart';
import 'package:personal_wellness/feature/progress/screen/progress.dart';
import 'package:personal_wellness/feature/routine/screen/reoutine.dart';
import 'package:personal_wellness/feature/today/screen/today.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final BottomNavcontroller controller = Get.put(BottomNavcontroller());


  final List<Widget> screens = [
    Today(),
    Explore(),
    Routine(),
    ProgressData(),
  ];

  final List<String> activeIcons = [
    IconPath.todayactive,//
    IconPath.exploreactive,
    IconPath.routineactive,
    IconPath.progressactive,
  ];

  final List<String> inactiveIcons = [
    IconPath.todayinactive,
    IconPath.exploreinactive,
    IconPath.routineinactive,
    IconPath.progressinactive,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      backgroundColor: Color(0xffFFFFFF),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            overlayColor: WidgetStatePropertyAll(
              Color(0xffFFFFFF), // Adjusted alpha for overlay
            ),
    
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontSize: 13.sp,
                  fontFamily: "SFPro",
                  fontWeight: FontWeight.w400,
                  color:Color(0xff3E4B2C),
                ); // Assuming secondary is defined in colors.dart
              }
              return TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff0E1701), 
                 fontFamily: "SFPro",// Assuming lebelColor is defined
              );
            }),
          ),
          child: NavigationBar(
             indicatorColor: Colors.transparent,
            elevation: 9,
          height: 55.h,
            shadowColor: Colors.black,
            backgroundColor:Color(0xffFFFFFF),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (int index) {
              controller.changeIndex(index);
            },
            destinations: [
              NavigationDestination(
                icon: controller.selectedIndex.value == 0
                    ? Image.asset(activeIcons[0], width: 24)
                    : Image.asset(inactiveIcons[0], width: 24),
                label: 'Today',
              ),
              NavigationDestination(
                icon: controller.selectedIndex.value == 1
                    ? Image.asset(activeIcons[1], width: 24)
                    : Image.asset(inactiveIcons[1], width: 24),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: controller.selectedIndex.value == 2
                    ? Image.asset(activeIcons[2], width: 24)
                    : Image.asset(inactiveIcons[2], width: 24),
                label: 'Routine',
              ),
              NavigationDestination(
                icon: controller.selectedIndex.value == 3
                    ? Image.asset(activeIcons[3], width: 24)
                    : Image.asset(inactiveIcons[3], width: 24),
                label: 'Progress',
              ),
            ],
          ),
        ),
      ),
    );
  }
}