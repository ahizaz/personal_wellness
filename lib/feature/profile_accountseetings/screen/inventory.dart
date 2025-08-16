
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/profile_accountseetings/controller/inventory_controller.dart';
import 'package:personal_wellness/feature/profile_accountseetings/widget/filter_popup.dart';
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
                        showFilterPopup(context, controller, filterKey); // Call the function from the separate file
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