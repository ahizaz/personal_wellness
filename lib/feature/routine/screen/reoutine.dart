import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class Routine extends StatelessWidget {
  const Routine({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineController controller = Get.put(RoutineController());

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
                // Display the added products
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.routines.map((routine) {
                        return Text(
                          routine.productName,
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff3E4B2C),
                          ),
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}