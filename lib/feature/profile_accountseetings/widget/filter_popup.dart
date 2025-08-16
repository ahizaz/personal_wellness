import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/profile_accountseetings/controller/inventory_controller.dart';

void showFilterPopup(
    BuildContext context, InventoryController controller, GlobalKey filterKey) {
  final RenderBox renderBox =
      filterKey.currentContext!.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;
  final double screenWidth = MediaQuery.of(context).size.width;

  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        overlayEntry!.remove();
      },
      child: Stack(
        children: [
          Positioned(
            right: 16.w,
            top: position.dy + size.height + 8.h,
            child: GestureDetector(
              onTap: () {},
              child: Material(
                color: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: screenWidth - 32.w,
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3E4B2C),
                            ),
                          ),
                          InkWell(
                            onTap: () => overlayEntry!.remove(),
                            borderRadius: BorderRadius.circular(30),
                            child: Icon(Icons.close, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Brand Section
                      Text(
                        "Brand",
                        style: TextStyle(
                            fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff172601),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(() => Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: controller.brands.map((brand) {
                              final isSelected =
                                  controller.selectedBrands.contains(brand);
                              return FilterChip(
                                label: Text(brand),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.selectedBrands.add(brand);
                                  } else {
                                    controller.selectedBrands.remove(brand);
                                  }
                                },
                                pressElevation: 0,
                                backgroundColor: Colors.white,
                                selectedColor: const Color(0xFFF0F0F0),
                                labelStyle:  TextStyle(
                               fontFamily: "SFPro",
                               fontSize: 17.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff172601)
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          )),
                      SizedBox(height: 8.h),
                      Text(
                        "Show more",
                        style: TextStyle(
                             fontFamily: "SFPro",
                          color: const Color(0xff172601),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Category Section
                      Text(
                        "Category",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff172601),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(() => Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: controller.categories.map((cat) {
                              final isSelected =
                                  controller.selectedCategories.contains(cat);
                              return FilterChip(
                                label: Text(cat),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.selectedCategories.add(cat);
                                  } else {
                                    controller.selectedCategories.remove(cat);
                                  }
                                },
                                pressElevation: 0,
                                backgroundColor: Colors.white,
                                selectedColor: const Color(0xFFF0F0F0),
                                labelStyle:  TextStyle(
                                    fontFamily: "SFPro",
                               fontSize: 17.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff172601)
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected
                                        ?Color(0xffEDEEE6)
                                        : Color(0xffE8E9E6),
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          )),
                      SizedBox(height: 8.h),
                      Text(
                        "Show more",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          color: const Color(0xff172601),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                controller.applyFilters();
                                overlayEntry!.remove();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3E4B2C),
                                shape: const StadiumBorder(),
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                              ),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                controller.resetFilters();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0F0F0),
                                foregroundColor: Colors.black87,
                                shape: const StadiumBorder(),
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                elevation: 0,
                              ),
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Overlay.of(context).insert(overlayEntry);
}