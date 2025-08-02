import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTermsText extends StatelessWidget {
  const CustomTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'SFPro',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff3E4B2C),
        ),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xff3E4B2C),
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xff3E4B2C),
            ),
          ),
        ],
      ),
    );
  }
}
