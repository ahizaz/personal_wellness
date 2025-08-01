import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';

class BackButtonWithTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const BackButtonWithTitle({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBackPressed ?? () => Get.back(),
          child: Row(
            children: [
              Image(
                image: const AssetImage(IconPath.back),
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
            title,
            style: TextStyle(
              fontFamily: 'SFPro',
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff172601),
            ),
          ),
        ),
      ],
    );
  }
}