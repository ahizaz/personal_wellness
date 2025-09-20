
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
                          onTap:(){
                              Get.to(()=>SkinCondition(
                                imagePath: item['image']!,
                                title: item['title']!,
                                id: item['id'],
                              ));
                          },
                          child: SizedBox(
                            width: 160.h,
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
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
            
              SizedBox(height: 12.h),
              SizedBox(
                height: 200.h, // Set a fixed height to limit the container
                child: Obx(() => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.sortedSkinTypes.length,
                      itemBuilder: (context, index) {
                        final item = controller.sortedSkinTypes[index];
                        return InkWell(
                          onTap: (){
                              Get.to(()=>SkinCondition(
                                imagePath: item['image']!,
                                title: item['title']!,
                                id: item['id'],
                              ));
                          },
                          child: SizedBox(
                            width: 160.h,
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
              Text("Products",style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff000000)
              ),),
              SizedBox(height: 12.h,),

            //products

              //products
Obx(() {
  final products = controller.sortedProducts;

  if (products.length < 4) {
    // ৪টা না এলে loader / empty দেখাও
    return const Center(child: Text("Not enough products"));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ViewProduct(),
                      arguments: products[0]["title"]);
                },
                child: SizedBox(
                  width: 178.w,
                  height: 182.h,
                  child: Image.network(
                    products[0]["image"] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                products[0]["title"] ?? "",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,///
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ViewProduct(),
                      arguments: products[1]["title"]);
                },
                child: SizedBox(
                  width: 178.w,
                  height: 182.h,
                  child: Image.network(
                    products[1]["image"] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                products[1]["title"] ?? "",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 16.h),
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ViewProduct(),
                      arguments: products[2]["title"]);
                },
                child: SizedBox(
                  width: 178.w,
                  height: 182.h,
                  child: Image.network(
                    products[2]["image"] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                products[2]["title"] ?? "",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => ViewProduct(),
                      arguments: products[3]["title"]);
                },
                child: SizedBox(
                  width: 178.w,
                  height: 182.h,
                  child: Image.network(
                    products[3]["image"] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                products[3]["title"] ?? "",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}),

            ],
          ),
        ),
      ),
    );
  }
}