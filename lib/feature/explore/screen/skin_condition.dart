import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:personal_wellness/feature/explore/controller/explore_controller.dart';
import 'package:personal_wellness/feature/explore/screen/view_product.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class SkinCondition extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? id;

  const SkinCondition({
    super.key,
    required this.imagePath,
    required this.title,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final exploreController = Get.find<ExploreController>();
    
    if (id != null && exploreController.currentSkinId.value != id) {
      exploreController.currentSkinId.value = id!;
      exploreController.fetchRecommendedProducts(id!);
    }

    return Scaffold(
      backgroundColor: const Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductHeader(title: 'Skin conditions'),
                SizedBox(height: 9.h),
                SizedBox(
                  width: double.infinity,
                  height: 298.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      imagePath,
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
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff000000),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Symptoms",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff172601),
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(() {
                  // Find the current skin condition data from API
                  Map<String, dynamic>? currentSkinData;
                  try {
                    currentSkinData = exploreController.skinConditions.firstWhere(
                      (item) => item['title'] == title && item['image'] == imagePath,
                    );
                  } catch (e) {
                    currentSkinData = null;
                  }
                  
                  return Text(
                    currentSkinData?['symptoms']?.toString() ?? 
                    exploreController.skinDetails["symptoms"],
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff3E4B2C),
                    ),
                  );
                }),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Treatment",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff172601),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(() {
                          // Find the current skin condition data from API
                          Map<String, dynamic>? currentSkinData;
                          try {
                            currentSkinData = exploreController.skinConditions.firstWhere(
                              (item) => item['title'] == title && item['image'] == imagePath,
                            );
                          } catch (e) {
                            currentSkinData = null;
                          }
                          
                          final treatments = currentSkinData?['treatment'] as List? ?? 
                                           exploreController.skinDetails["treatments"] as List;
                          
                          return Column(
                            children: List.generate(
                              treatments.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 9),
                                      child: Container(
                                        width: 6.w,
                                        height: 6.h,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff78816C),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 18.w),
                                    Expanded(
                                      child: Text(
                                        treatments[index].toString(),
                                        style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff3E4B2C),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                         
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h,),
                Text("Recommended products",style: TextStyle(fontFamily: "SFPro",fontSize: 28.sp,fontWeight: FontWeight.w400,color: Color(0xff172601)),),
                SizedBox(height: 16.h,),
                Obx(() {
                  final recProducts = exploreController.recommendedProducts;
                  if (recProducts.isEmpty) {
                    return const Text("No recommended products available");
                  }
                  return Row(
                    children: [
                      if (recProducts.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 177.w,
                            height: 182.h,
                            child: InkWell(
                              onTap: () {
                                Get.to(() => ViewProduct(), arguments: recProducts[0]["title"]!);
                              },
                              child: Image.network(
                                recProducts[0]["image"]!,
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
                          SizedBox(height: 8.h,),
                          Text(
                            recProducts[0]["title"]!,
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 16.w,),
                      if (recProducts.length > 1)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 177.w,
                            height: 182.h,
                            child: InkWell(
                              onTap: () {
                                Get.to(() => ViewProduct(), arguments: recProducts[1]["title"]!);
                              },
                              child: Image.network(
                                recProducts[1]["image"]!,
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
                          SizedBox(height: 8.h,),
                          Text(
                            recProducts[1]["title"]!,
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}