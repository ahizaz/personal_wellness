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
                                    color: Color(0xffFFFFFF).withOpacity(0.4),
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
                                    color: Color(0xffFFFFFF).withOpacity(0.4),
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
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff172601)),
                      maxLines: 1,
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
                    // Show relevant products dynamically from API
                    return Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      children: controller.relevantProducts.map((prod) {
                        return SizedBox(
                          width: 177.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              prod["image"] != ""
                                ? Image.network(prod["image"], width: 177.w, height: 182.h, fit: BoxFit.cover)
                                : Container(
                                    width: 177.w,
                                    height: 182.h,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported, size: 40),
                                  ),
                              SizedBox(height: 8.h),
                              Text(
                                prod["productName"] ?? "",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000)
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
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