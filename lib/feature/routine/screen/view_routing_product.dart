// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:personal_wellness/core/utils/constants/icon_path.dart';

// class ViewRoutingProduct extends StatelessWidget {
//   final String productName;
// const ViewRoutingProduct({super.key, required this.productName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffEDEEE6),
//       body: SafeArea(child: SingleChildScrollView(
//         child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20.h,),
//             Row(
//               children: [
//                   InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: Image.asset(
//             IconPath.backarrow,
//             width: 24.w,
//             height: 24.h,
//             fit: BoxFit.cover,
//           ),
//         ),
//          SizedBox(width: 110.w),
//          Center(
//           child: Text(productName,style: const TextStyle(
//                           fontFamily: "SFPro",
//                           fontSize: 17,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xff172601),
//                         ),
//                         ),
                        
//          ),
//    Spacer(),
//    Image(image: AssetImage(IconPath.edit),height: 40.w,width: 40.w,fit: BoxFit.cover,)
     

//               ],
//             )
//           ],
//         ),
//         ),
        
//       )),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';

class ViewRoutingProduct extends StatelessWidget {
  final String productName;
  const ViewRoutingProduct({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    var editedName = productName.obs; // Observable to track the edited name

    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        IconPath.backarrow,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 110.w),
                    Obx(() => Center(
                          child: editedName.value.isEmpty
                              ? Text(
                                  productName,
                                  style: const TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff172601),
                                  ),
                                )
                              : Text(
                                  editedName.value,
                                  style: const TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff172601),
                                  ),
                                ),
                        )),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          title: "Edit Product Name",
                          content: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "Enter new name",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  editedName.value = value;
                                },
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      // Here you can add logic to save the editedName if needed
                                    },
                                    child: Text("Save"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: Image(
                        image: AssetImage(IconPath.edit),
                        height: 40.w,
                        width: 40.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}