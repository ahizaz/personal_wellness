import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class CategoryBottomSheet extends StatelessWidget {
  const CategoryBottomSheet({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Choose category',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff172601),
                  fontFamily: 'SFPro',
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Image.asset(IconPath.cleanser, color: Colors.white, width: 16, height: 16),
              ),
              title: const Text('Cleanser'),
              trailing: Obx(() => controller.selectedCategory.value == 'Cleanser'
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox.shrink()),
              onTap: () {
                controller.selectedCategory.value = 'Cleanser';
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.pink,
                child: Image.asset(IconPath.serum, color: Colors.white, width: 16, height: 16),
              ),
              title: const Text('Serum'),
              trailing: Obx(() => controller.selectedCategory.value == 'Serum'
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox.shrink()),
              onTap: () {
                controller.selectedCategory.value = 'Serum';
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black,
                child: Image.asset(IconPath.night, color: Colors.white, width: 16, height: 16),
              ),
              title: const Text('Night Cream'),
              trailing: Obx(() => controller.selectedCategory.value == 'Night Cream'
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox.shrink()),
              onTap: () {
                controller.selectedCategory.value = 'Night Cream';
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.yellow,
                child: Image.asset(IconPath.sun, color: Colors.white, width: 16, height: 16),
              ),
              title: const Text('Sun Cream'),
              trailing: Obx(() => controller.selectedCategory.value == 'Sun Cream'
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox.shrink()),
              onTap: () {
                controller.selectedCategory.value = 'Sun Cream';
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.purple,
                child: Image.asset(IconPath.lotion, color: Colors.white, width: 16, height: 16),
              ),
              title: const Text('Lotion'),
              trailing: Obx(() => controller.selectedCategory.value == 'Lotion'
                  ? const Icon(Icons.check, color: Colors.green)
                  : const SizedBox.shrink()),
              onTap: () {
                controller.selectedCategory.value = 'Lotion';
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16.h),
           Center(
            child: InkWell(
              onTap:(){
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: Color(0xff172601),
                  borderRadius: BorderRadius.circular(999.r),

                ),
                child: Center(
                  child: Text("Done",style:TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFFFFFF)
                  ),),
                ),

              ),
            ),
           ),
           SizedBox(height: 16.h,),
          ],
        ),
      ),
    );
  }
}