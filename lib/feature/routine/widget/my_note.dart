import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';
///myNOte
class MyNote extends StatelessWidget {
  const MyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewProductController controller = Get.put(ViewProductController());

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Color(0xffFFFFFF),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My note",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff172601),
              ),
            ),
            SizedBox(height: 12.h),
           Obx(() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: controller.mynote.map<Widget>((item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff3E4B2C),
              ),
            ),
          ),
        ],
      ),
    );
  }).toList(),
)),


          ],
        ),
      ),
    );
  }
}