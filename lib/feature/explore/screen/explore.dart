import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:personal_wellness/feature/explore/controller/explore_controller.dart';
import 'package:personal_wellness/feature/explore/screen/skin_condition.dart';
import 'package:personal_wellness/feature/explore/screen/view_product.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final ExploreController controller = Get.put(ExploreController());
    final TextEditingController searchController = TextEditingController();

    searchController.addListener(() {
      controller.searchTerm.value = searchController.text;
    });

    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Color(0xff78816C).withAlpha(153),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search e.g. Pimple skin, serum etc.',
                    hintStyle: TextStyle(
                      fontFamily: "SFPro",
                      color: Color(0xff78816C),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 17.h),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff3E4B2C),
                      size: 24.sp,
                    ),
                  ),
                  style: TextStyle(
                    color: Color(0xff78816C),
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Skin condition",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff172601),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 200.h, // Set a fixed height to limit the container
                child: Obx(() => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.sortedSkinConditions.length,
                      itemBuilder: (context, index) {
                        final item = controller.sortedSkinConditions[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => SkinCondition(
                                  imagePath: item['image']!,
                                  title: item['title']!,
                                  id: item['id'],
                                ));
                          },
                          child: Container(
                            width: 160.h,
                            margin: EdgeInsets.only(right: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 160.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      item["image"]!,
                                      fit: BoxFit.cover,
                                      cacheWidth: 320, // Optimize image loading
                                      cacheHeight: 320,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.broken_image, color: Colors.grey[600], size: 24),
                                              SizedBox(height: 4),
                                              Text(
                                                'Image failed',
                                                style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xff3E4B2C),
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                                SizedBox(height: 4),
                                                Text('Loading...',
                                                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  item["title"]!,
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ), ///
              SizedBox(height: 12.h),
              //2nd one
              SizedBox(
                height: 220.h, // Set a fixed height to limit the container
                child: Obx(() => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.sortedSkinTypes.length,
                      itemBuilder: (context, index) {
                        final item = controller.sortedSkinTypes[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => SkinCondition(
                                  imagePath: item['image']!,
                                  title: item['title']!,
                                  id: item['id'],
                                ));
                          },
                          child: Container(
                            width: 160.h,
                            margin: EdgeInsets.only(right: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 160.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      item["image"]!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(Icons.error, color: Colors.grey[600]),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  item["title"]!,
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
              SizedBox(height: 24.h,),
            Text(
                "Products",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff172601),
                ),
              ),
              SizedBox(height: 12.h,),

              // ---- Updated products section: show ALL products vertically (changed from horizontal) ----
              Obx(() {
                final products = controller.sortedProducts;

                if (products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Text("No products found",
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey[700])),
                    ),
                  );
                }

                // Because the parent is a SingleChildScrollView (vertical), we must
                // make the inner ListView non-scrolling and let the outer scroll view handle it.
                return Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => ViewProduct(), arguments: product["id"]);
                                },
                                child: Container(
                                  width: 120.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      product["image"] ?? "",
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: const Icon(Icons.broken_image),
                                      ),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => ViewProduct(), arguments: product["id"]);
                                      },
                                      child: Text(
                                        product["title"] ?? "",
                                        style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff3E4B2C),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    // If you have a short description or price, show here.
                                    if ((product["description"] ?? "").isNotEmpty)
                                      Text(
                                        product["description"] ?? "",
                                        style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Load More Button
                    if (controller.hasMoreProducts)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Obx(() => controller.isLoadingMore.value
                            ? CircularProgressIndicator(
                                color: Color(0xff3E4B2C),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  controller.loadMoreProducts();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff3E4B2C),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Load More',
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                      ),
                  ],
                );
              }),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}