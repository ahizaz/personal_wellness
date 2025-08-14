
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';
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
      backgroundColor: Color(0xffEDEEE6),
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
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          title: "Edit Product Name",
                          content: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
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
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      // Here you can add logic to save the editedName if needed
                                    },
                                    child: Text("Save"),
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
                SizedBox(height: 16.h,),
                        Stack(
  alignment: Alignment.center,
  children: [
    // Reactive image container
    Obx(() => Container(
          width: double.infinity,
          height: 298.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  controller.imagePath[controller.currentIndex.value]),
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
                          ? Color(0xffFFFFFF)
                          : Color(0xffEDEEE6),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 28.w,
                      height: 2.h,
                      color: controller.currentIndex.value >= 1
                          ? Color(0xffFFFFFF)
                          : Color(0xffEDEEE6),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 28.w,
                      height: 2.h,
                      color: controller.currentIndex.value >= 2
                          ? Color(0xffFFFFFF)
                          : Color(0xffEDEEE6),
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
                  color: Color(0xffFFFFFF).withValues(alpha: 0.4),
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
        : SizedBox()),

    // Right arrow - only show if not on last image
    Obx(() => controller.currentIndex.value < controller.imagePath.length - 1
        ? Positioned(
            right: 16.w,
            child: InkWell(
              onTap: controller.nextImage,
              child: Container(
                width: 32.w,
                height: 182.h,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF).withValues(alpha: 0.4),
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
        : SizedBox()),
  ],
),
 SizedBox(height: 16.h,),
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
                    color: Color(0xff172601),
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
                         color: Color(0xff3E4B2C),
                       ),
                       maxLines: isDescriptionExpanded.value ? null : 2,
                       overflow: isDescriptionExpanded.value
                           ? TextOverflow.visible
                           : TextOverflow.ellipsis,
                     ),
                     SizedBox(height: 8.h),
                     GestureDetector(
                       onTap: () {
                         isDescriptionExpanded.value = !isDescriptionExpanded.value;
                       },
                       child: Text(
                         isDescriptionExpanded.value ? "Show less" : "Show more",
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
                 SizedBox(height: 16.h,),
                 UsageDirection(),
                 SizedBox(height: 16.h,),
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


              ],
            ),
          ),
        ),
      ),
    );
  }
}