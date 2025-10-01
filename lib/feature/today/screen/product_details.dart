import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/today/controller/product_details_controller_new.dart';
import 'package:personal_wellness/feature/today/widget/how_to_use.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsController controller = Get.put(ProductDetailsController());
    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductHeader(title: 'Product',),
                SizedBox(height: 9.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Single Obx wrapping the entire reactive Container
                    Obx(() => Container(
                          width: double.infinity,
                          height: 298.h,
                          decoration: BoxDecoration(
                            image: controller.productImages.isNotEmpty 
                              ? DecorationImage(
                                  image: NetworkImage(
                                      controller.productImages[controller.currentIndex.value]),
                                  fit: BoxFit.cover,
                                ) 
                              : DecorationImage(
                                  image: AssetImage("assets/images/produt_details_1.png"),
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
                                  children: List.generate(
                                    controller.productImages.isNotEmpty 
                                      ? controller.productImages.length 
                                      : 3,
                                    (index) => Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                                      width: 28.w,
                                      height: 2.h,
                                      color: controller.currentIndex.value == index
                                          ? Color(0xffFFFFFF)
                                          : Color(0xffEDEEE6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
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
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Obx(() => Text(
                  controller.productName.value.isNotEmpty 
                    ? controller.productName.value 
                    : "Loading...",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff172601),
                  ),
                )),
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
                Obx(() => Text(
                  controller.ingredients.value.isNotEmpty 
                    ? controller.ingredients.value 
                    : "Loading ingredients...",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff3E4B2C),
                  ),
                )),
                SizedBox(height: 16.h),
                HowToUseSection(),
                SizedBox(height: 24.h,),
                Text("Relevant products",style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff172601)
                ),),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product4,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("The Ordinary Anti-\naging Serum",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),
                      SizedBox(width: 16.w,),
                         Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product3,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("Whitening Night\nCream",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),

                  ],
                ),
                SizedBox(height: 16.h,),
                    Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product2,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("Vitamin C Serum\n50g",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),
                      SizedBox(width: 16.w,),
                         Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(ImagePath.product1,width: 177.w,height: 182.h,fit: BoxFit.cover,),
                        SizedBox(height: 8.h,),
                        Text("Essence Sun’s\nCream SPF45 ",style: TextStyle(fontFamily:"SFPro",fontSize: 17.sp,fontWeight: FontWeight.w600,color:Color(0xff000000)),)
                      ],
                    ),

                  ],
                ),
                  SizedBox(height: 14.h,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}