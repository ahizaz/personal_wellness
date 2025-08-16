

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';
import 'package:personal_wellness/feature/routine/widget/my_note.dart';
import 'package:personal_wellness/feature/routine/widget/usage_direction.dart';

class ViewRoutingProduct extends StatelessWidget {
  final String productName;
  const ViewRoutingProduct({super.key, required this.productName});
  @override
  Widget build(BuildContext context) {
    final ViewProductController controller = Get.put(ViewProductController());
    var editedName = productName.obs; // Observable to track the edited name
    final RxBool isDescriptionExpanded = false.obs;
    return Scaffold(
      backgroundColor: const Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        IconPath.backarrow,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 110.w),
                    Obx(() => Center(
                          child: editedName.value.isEmpty
                              ? Text(
                                  productName,
                                  style: const TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff172601),
                                  ),
                                )
                              : Text(
                                  editedName.value,
                                  style: const TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff172601),
                                  ),
                                ),
                        )),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          title: "Edit Product Name",
                          content: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: "Enter new name",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  editedName.value = value;
                                },
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      // Here you can add logic to save the editedName if needed
                                    },
                                    child: const Text("Save"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: Image(
                        image: AssetImage(IconPath.edit),
                        height: 40.w,
                        width: 40.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Reactive image container
                    Obx(() => Container(
                          width: double.infinity,
                          height: 298.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(controller
                                  .imagePath[controller.currentIndex.value]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 28.w,
                                      height: 2.h,
                                      color: controller.currentIndex.value >= 0
                                          ? const Color(0xffFFFFFF)
                                          : const Color(0xffEDEEE6),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      width: 28.w,
                                      height: 2.h,
                                      color: controller.currentIndex.value >= 1
                                          ? const Color(0xffFFFFFF)
                                          : const Color(0xffEDEEE6),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      width: 28.w,
                                      height: 2.h,
                                      color: controller.currentIndex.value >= 2
                                          ? const Color(0xffFFFFFF)
                                          : const Color(0xffEDEEE6),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    // Left arrow - only show if not on first image
                    Obx(() => controller.currentIndex.value > 0
                        ? Positioned(
                            left: 16.w,
                            child: InkWell(
                              onTap: controller.prevImage,
                              child: Container(
                                width: 32.w,
                                height: 182.h,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xffFFFFFF).withAlpha(102), // withValues is deprecated
                                  borderRadius: BorderRadius.circular(11.r),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 20.r,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()),
                    // Right arrow - only show if not on last image
                    Obx(() => controller.currentIndex.value <
                            controller.imagePath.length - 1
                        ? Positioned(
                            right: 16.w,
                            child: InkWell(
                              onTap: controller.nextImage,
                              child: Container(
                                width: 32.w,
                                height: 182.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFFFFF)
                                      .withAlpha(102), // withValues is deprecated
                                  borderRadius: BorderRadius.circular(11.r),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.r,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  productName,
                  style: const TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Description",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff172601),
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.viewRoutingProductView["Description"],
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff3E4B2C),
                          ),
                          maxLines: isDescriptionExpanded.value ? null : 2,
                          overflow: isDescriptionExpanded.value
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () {
                            isDescriptionExpanded.value =
                                !isDescriptionExpanded.value;
                          },
                          child: Text(
                            isDescriptionExpanded.value
                                ? "Show less"
                                : "Show more",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff172601),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 16.h,
                ),
                const UsageDirection(),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Start date",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                            ),
                          ),
                          Obx(() => Text(
                                controller.routineDetails.value.startDate,
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff3E4B2C),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "End date",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                            ),
                          ),
                          Obx(() => Text(
                                controller.routineDetails.value.endDate,
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff3E4B2C),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Frequency",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                            ),
                          ),
                          Obx(() => Text(
                                controller.routineDetails.value.frequency,
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff3E4B2C),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                const MyNote(),
                SizedBox(
                  height: 24.h,
                ),
                InkWell(
                  onTap: () {
                    // *** এখানে কোড পরিবর্তন করা হয়েছে ***
                    Get.generalDialog(
                      barrierDismissible: true,
                      barrierLabel: 'Dismiss',
                      barrierColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, anim1, anim2) {
                        return Center(
                          child: Container(
                            width: 342.w,
                            padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72.w,
                                  height: 72.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff16A34A), // Green color
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 40.sp,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "Congratulations!",
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff172601),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "You have successfully completed this.",
                                  textAlign: TextAlign.center,
                                  
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff3E4B2C),
                                     decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                TextButton(
                                  onPressed: () {
                                    Get.back(); // ডায়ালগ বন্ধ করার জন্য
                                  },
                                  child: Text(
                                    "Back to routine",
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      backgroundColor: Colors.transparent,
                                      color: const Color(0xff172601),
                                       decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return FadeTransition(
                          opacity: anim1,
                          child: child,
                        );
                      },
                    );
                    // *** পরিবর্তন শেষ ***
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999.r),
                        color: const Color(0xff172601)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            size: 24.w, // weight is not a property of Icon
                            color: const Color(0xffFFFFFF),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "Mark as Complete",
                            style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xffFFFFFF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}