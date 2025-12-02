import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isFocused;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomProfileTextField({
    super.key,
    required this.controller,
    required this.isFocused,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        isFocused.value = focus;
      },
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isFocused.value || controller.text.isNotEmpty
                  ? const Color(0xff485908)
                  : const Color(0xffE8E9E6),
              width: isFocused.value || controller.text.isNotEmpty ? 3.w : 1.w,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.name,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 17.sp,
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w400,
              color: const Color(0xff172601),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 17.sp,
                fontFamily: 'SFPro',
                fontWeight: FontWeight.w400,
                color: const Color(0xff999999),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        );
      }),
    );
  }
}
