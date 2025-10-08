import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/explore/controller/view_product_controller.dart';
import 'package:personal_wellness/feature/explore/screen/add_to_routine.dart';
import 'package:personal_wellness/feature/explore/widget/howtoUseit.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewProductController controller = Get.put(ViewProductController());

    // Get productId from arguments and fetch product details
    final String? productId = Get.arguments as String?;
    if (productId != null) {
      controller.fetchProductDetails(productId);
    }

    return Scaffold(
      backgroundColor: const Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Obx(() {
              if (controller.productDataview.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeader(title: 'Product'),
                  SizedBox(height: 9.h),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Reactive image container
                      Obx(() => Container(
                        width: double.infinity,
                        height: 298.h,
                        decoration: BoxDecoration(
                          image: controller.imagePath.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(controller.imagePath[controller.currentIndex.value]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(controller.imagePath.length, (i) {
                                    return Container(
                                      width: 28.w,
                                      height: 2.h,
                                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                                      color: controller.currentIndex.value == i ? Color(0xffFFFFFF) : Color(0xffEDEEE6),
                                    );
                                  }),
                                ),
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
                  SizedBox(height: 16.h),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      controller.productDataview["productName"] ?? "",
                      style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff172601)),
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Ingredients",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff172601),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    controller.productDataview["ingredients"] ?? "",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff3E4B2C),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Howtouseit(),
                  SizedBox(height: 24.h),
                  InkWell(
                    onTap: () {
                      // Pass both product name and ID to AddToRoutine
                      Get.to(AddToRoutine(), arguments: {
                        "productName": controller.productDataview["productName"],
                        "productId": controller.productDataview["_id"],
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Color(0xff172601),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Center(
                        child: Text("+   Add to my routine", style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFFFFFF)
                        )),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Timeline Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Timeline", style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff172601)
                      )),
                      InkWell(
                        onTap: () => controller.refreshTimelineData(),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Color(0xff172601).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.refresh,
                            size: 20.r,
                            color: Color(0xff172601),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.timelineData.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Color(0xffF5F6F0),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Color(0xffE0E0E0), width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo_camera,
                              color: Color(0xff3E4B2C),
                              size: 24.r,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                "No progress photos yet. Start tracking your journey!",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff3E4B2C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return Column(
                      children: [
                        // Display latest 3 timeline images in a row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: controller.timelineData.take(3).map((item) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        item["image"],
                                        width: double.infinity,
                                        height: 120.h,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            width: double.infinity,
                                            height: 120.h,
                                            color: Color(0xffF5F6F0),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xff172601),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 120.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xffF5F6F0),
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_not_supported,
                                                  size: 32.r,
                                                  color: Color(0xff3E4B2C),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  "Image not\navailable",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: "SFPro",
                                                    fontSize: 10.sp,
                                                    color: Color(0xff3E4B2C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    item["label"] ?? "Day 1",
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff172601),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item["date"] ?? "",
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff3E4B2C),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 24.h),
                  
                  Text("Relevant products", style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff172601)
                  )),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.relevantProducts.isEmpty) {
                      return Text(
                        "No relevant products found.",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3E4B2C),
                        ),
                      );
                    }
                    // Show relevant products dynamically from API in parallel rows
                    return Column(
                      children: [
                        for (int i = 0; i < controller.relevantProducts.length; i += 2)
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First product in the row
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8.r),
                                          child: controller.relevantProducts[i]["image"] != ""
                                            ? Image.network(
                                                controller.relevantProducts[i]["image"], 
                                                width: double.infinity, 
                                                height: 182.h, 
                                                fit: BoxFit.cover
                                              )
                                            : Container(
                                                width: double.infinity,
                                                height: 182.h,
                                                color: Colors.grey[300],
                                                child: Icon(Icons.image_not_supported, size: 40),
                                              ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          controller.relevantProducts[i]["productName"] ?? "",
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000)
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Add spacing between products
                                SizedBox(width: 16.w),
                                // Second product in the row (or empty space if odd number)
                                Expanded(
                                  child: i + 1 < controller.relevantProducts.length
                                    ? Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8.r),
                                              child: controller.relevantProducts[i + 1]["image"] != ""
                                                ? Image.network(
                                                    controller.relevantProducts[i + 1]["image"], 
                                                    width: double.infinity, 
                                                    height: 182.h, 
                                                    fit: BoxFit.cover
                                                  )
                                                : Container(
                                                    width: double.infinity,
                                                    height: 182.h,
                                                    color: Colors.grey[300],
                                                    child: Icon(Icons.image_not_supported, size: 40),
                                                  ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              controller.relevantProducts[i + 1]["productName"] ?? "",
                                              style: TextStyle(
                                                fontFamily: "SFPro",
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff000000)
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(), // Empty space for odd number of products
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 14.h),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}