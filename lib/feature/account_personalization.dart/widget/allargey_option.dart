import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllergyOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const AllergyOption({
    super.key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xff485908) : Color(0xffE8E9E9),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff172601),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff172601),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8.w,
                right: 8.w,
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xff485908),
                  size: 20.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}