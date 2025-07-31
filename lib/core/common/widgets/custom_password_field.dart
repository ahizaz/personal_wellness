// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// // import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/password_controller.dart';

// // class CustomPasswordField extends StatelessWidget {
// //   final PasswordController passwordController = Get.put(PasswordController());

// //   CustomPasswordField({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(() {
// //       final borderColor = passwordController.hasText.value
// //           ? Color(0xff172601)
// //           : const Color(0xffE8E9E6);

// //       return Container(
// //         width: double.infinity,
// //         height: 56.h,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(
// //             width: 1,
// //             color: borderColor,
// //           ),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 12),
// //           child: Row(
// //             children: [
// //               Expanded(
// //                 child: TextField(
// //                   controller: passwordController.passwordController,
// //                   obscureText: !passwordController.isPasswordVisible.value,
// //                   decoration: const InputDecoration(
// //                     hintText: "Password",
// //                     border: InputBorder.none,
// //                   ),
// //                 ),
// //               ),
// //               GestureDetector(
// //                 onTap: passwordController.toggleVisibility,
// //                 child: Icon(
// //                   passwordController.isPasswordVisible.value
// //                       ? Icons.visibility
// //                       : Icons.visibility_off,
// //                   color: Colors.grey,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     });
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/password_controller.dart';

// class CustomPasswordField extends StatelessWidget {
//   final PasswordController passwordController = Get.find<PasswordController>();

//   CustomPasswordField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final borderColor = passwordController.passwordStrength.value != 'none'
//           ? const Color(0xff172601)
//           : const Color(0xffE8E9E6);

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             height: 56.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 width: 1,
//                 color: borderColor,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: passwordController.passwordController,
//                       obscureText: !passwordController.isPasswordVisible.value,
//                       decoration: const InputDecoration(
//                         hintText: "Password",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: passwordController.toggleVisibility,
//                     child: Icon(
//                       passwordController.isPasswordVisible.value
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           // Password strength indicator
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               _buildStrengthBar(
//                   isActive: passwordController.passwordStrength.value != 'none'),
//               SizedBox(width: 4.w),
//               _buildStrengthBar(
//                   isActive: passwordController.passwordStrength.value == 'medium' ||
//                       passwordController.passwordStrength.value == 'strong'),
//               SizedBox(width: 4.w),
//               _buildStrengthBar(
//                   isActive: passwordController.passwordStrength.value == 'strong'),
//             ],
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             passwordController.passwordStrength.value.capitalizeFirst ?? '',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: _getStrengthColor(passwordController.passwordStrength.value),
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _buildStrengthBar({required bool isActive}) {
//     return Container(
//       width: 30.w,
//       height: 4.h,
//       decoration: BoxDecoration(
//         color: isActive ? const Color(0xff172601) : const Color(0xffE8E9E6),
//         borderRadius: BorderRadius.circular(2.r),
//       ),
//     );
//   }

//   Color _getStrengthColor(String strength) {
//     switch (strength) {
//       case 'easy':
//         return Colors.red;
//       case 'medium':
//         return Colors.orange;
//       case 'strong':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/password_controller.dart';

class CustomPasswordField extends StatelessWidget {
  final PasswordController passwordController = Get.find<PasswordController>();

  CustomPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final borderColor = passwordController.passwordStrength.value != 'none'
          ? const Color(0xff172601)
          : const Color(0xffE8E9E6);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1,
                color: borderColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordController.passwordController,
                      obscureText: !passwordController.isPasswordVisible.value,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: passwordController.toggleVisibility,
                    child: Icon(
                      passwordController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // Password strength indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildStrengthBar(
                  isActive: passwordController.passwordStrength.value != 'none'),
              SizedBox(width: 6.w),
              _buildStrengthBar(
                  isActive: passwordController.passwordStrength.value == 'medium' ||
                      passwordController.passwordStrength.value == 'strong'),
              SizedBox(width: 6.w),
              _buildStrengthBar(
                  isActive: passwordController.passwordStrength.value == 'strong'),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            passwordController.passwordStrength.value.capitalizeFirst ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: _getStrengthColor(passwordController.passwordStrength.value),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStrengthBar({required bool isActive}) {
    return Container(
      width: 100.w, // Increased width
      height: 3.h, // Increased height
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff172601) : const Color(0xffE8E9E6),
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }

  Color _getStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}