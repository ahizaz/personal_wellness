import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  fontSize: 17.sp,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.w600,
       
                  color: const Color(0xFFFFFFFF),
                ),
          ),
        ),
      ),
    );
  }
}
