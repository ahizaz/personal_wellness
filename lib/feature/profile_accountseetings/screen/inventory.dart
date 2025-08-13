
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/profile_accountseetings/controller/inventory_controller.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    final InventoryController controller = Get.put(InventoryController());
    final TextEditingController searchController = TextEditingController();
    searchController.addListener(() {
      controller.searchTerm.value = searchController.text;
    });
    final GlobalKey filterKey = GlobalKey();

    return Scaffold(
      backgroundColor: const Color(0xffEDEEE6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProductHeader(title: 'Inventory'),
              SizedBox(height: 25.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: const Color(0xff78816C).withAlpha(153),
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search....',
                          hintStyle: TextStyle(
                            fontFamily: "SFPro",
                            color: const Color(0xff78816C),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 17.h),
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color(0xff3E4B2C),
                            size: 24.sp,
                          ),
                        ),
                        style: TextStyle(
                          color: const Color(0xff78816C),
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => InkWell(
                      key: filterKey,
                      onTap: () {
                        _showFilterPopup(context, controller, filterKey);
                      },
                      child: Container(
                        width: 56.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.isFilterActive.value
                              ? const Color(0xff3E4B2C)
                              : const Color(0xffFFFFFF),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.filter_list,
                            color: controller.isFilterActive.value
                                ? const Color(0xffFFFFFF)
                                : const Color(0xff3E4B2C),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                "Products",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(() {
                  if (controller.sortedProducts.isEmpty) {
                    return const Center(child: Text("No products found."));
                  }
                  return GridView.builder(
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 178 / (182 + 8 + 40),
                    ),
                    itemCount: controller.sortedProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.sortedProducts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: AspectRatio(
                              aspectRatio: 178 / 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.asset(
                                  product["image"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            product["title"]!,
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Filter Popup Function ===
void _showFilterPopup(
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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
                                labelStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
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
                          color: const Color(0xff3E4B2C),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Category Section
                      Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
                                labelStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
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
                          color: const Color(0xff3E4B2C),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
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
