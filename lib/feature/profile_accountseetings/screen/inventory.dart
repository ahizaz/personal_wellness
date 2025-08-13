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

    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ProductHeader(title: 'Inventory',),
             SizedBox(height: 25.h,),
             Row(
              children: [
                Expanded(child: Container(
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
                    
                    hintText: 'Search....',
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
              ),),
              SizedBox(width: 8.w,),
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFFFFFF)
                  
                ),
                child: Center(
                  child: Icon(Icons.filter_list),
                ),
              ),
              SizedBox(height: 16.h,),
              
              ],
             ),
             SizedBox(height: 16.h,),
               Text("Products",style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 34.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff000000)
              ),),
                Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                        width: 178.w,
                        height: 182.h,
                        child:  InkWell(onTap:(){
                        
                        },child: Image(image: AssetImage(controller.sortedProducts[0]["image"]!),fit: BoxFit.cover,)),
                       ),
                       SizedBox(height: 8.h,),
                       Text(controller.sortedProducts[0]["title"]!,style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500
                     
                       ),)
                      ],
                     ),
                     SizedBox(width: 8.w,),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                        width: 178.w,
                        height: 182.h,
                        child:  InkWell(onTap:(){
                   
                        },child: Image(image: AssetImage(controller.sortedProducts[1]["image"]!),fit: BoxFit.cover,)),
                       ),
                       SizedBox(height: 8.h,),
                       Text(controller.sortedProducts[1]["title"]!,style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500

                       ),)
                      ],
                     ),
                    ],
                  ),



                  SizedBox(height: 16.h,),
                   Row(
                    children: [
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                        width: 178.w,
                        height: 182.h,
                        child:  InkWell(onTap: (){
                         
                        },child: Image(image: AssetImage(controller.sortedProducts[2]["image"]!),fit: BoxFit.cover,)),
                       ),
                       SizedBox(height: 8.h,),
                       Text(controller.sortedProducts[2]["title"]!,style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500

                       ),)
                      ],
                     ),
                     SizedBox(width: 8.w,),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                        width: 178.w,
                        height: 182.h,
                        child:  InkWell(onTap: (){
                    
                        },child: Image(image: AssetImage(controller.sortedProducts[3]["image"]!),fit: BoxFit.cover,)),
                       ),
                       SizedBox(height: 8.h,),
                       Text(controller.sortedProducts[3]["title"]!,style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500

                       ),)
                      ],
                     ),
                    ],
                  ),
                ],
              )),

          ],
        ),
        ),

      )),
    );
  }
}