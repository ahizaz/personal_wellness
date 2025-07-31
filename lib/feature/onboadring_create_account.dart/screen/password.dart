// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:personal_wellness/core/common/widgets/custom_password_field.dart';
// import 'package:personal_wellness/core/utils/constants/icon_path.dart';
// import 'package:personal_wellness/core/utils/constants/image_path.dart';
// class Password extends StatelessWidget {
//   const Password({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//           decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(ImagePath.accountBackground),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               width: double.infinity,
//               height: 326.h,
//                decoration: BoxDecoration(
//                   color: const Color(0xffFFFFFF),
//                   borderRadius: BorderRadius.circular(32.r),
//                 ),
//                 child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                      SizedBox(height: 33.h),
//                      Row(
//                       children: [
//                         InkWell(
//                       onTap: (){
//                         Get.back();
//                       },
//                        child: Row(
//                         children: [
//                           Image(image: AssetImage(IconPath.back),
//                           height: 32.h,
//                           width: 32.h,
//                           fit: BoxFit.cover,
//                           ),
//                         ],
//                        ),
//                      ),
//                      SizedBox(width: 70.w,),
//                      Center(
//                        child: Text('Create Password',style: TextStyle(
//                         fontFamily: 'SFPro',
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xff172601)
//                        ),),
//                      )
//                       ],
//                      ),
//                      SizedBox(height: 33.h,),
//                   CustomPasswordField(),

//                   ],
//                 ),       
//                 ),
//             ),
//                 SizedBox(height: 30.h),
//           ],
//         ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_password_field.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/password_controller.dart';

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the PasswordController
    Get.put(PasswordController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.accountBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: 326.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 33.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(IconPath.back),
                                  height: 32.h,
                                  width: 32.h,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 70.w),
                          Center(
                            child: Text(
                              'Create Password',
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff172601),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 33.h),
                    CustomPasswordField(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}