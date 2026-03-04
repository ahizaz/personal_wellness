import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/terms_of_service_page.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/privacy_policy_page.dart';

class CustomTermsText extends StatefulWidget {
  const CustomTermsText({super.key});

  @override
  State<CustomTermsText> createState() => _CustomTermsTextState();
}

class _CustomTermsTextState extends State<CustomTermsText> {
  late final TapGestureRecognizer _termsTapRecognizer;
  late final TapGestureRecognizer _privacyTapRecognizer;

  @override
  void initState() {
    super.initState();
    _termsTapRecognizer = TapGestureRecognizer()
      ..onTap = () => Get.to(
            () => const TermsOfServicePage(),
            transition: Transition.noTransition,
          );
    _privacyTapRecognizer = TapGestureRecognizer()
      ..onTap = () => Get.to(
            () => const PrivacyPolicyPage(),
            transition: Transition.noTransition,
          );
  }

  @override
  void dispose() {
    _termsTapRecognizer.dispose();
    _privacyTapRecognizer.dispose();
    super.dispose();
  }

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
            recognizer: _termsTapRecognizer,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xff3E4B2C),
            ),
          ),
          const TextSpan(text: ' and\n'),
          TextSpan(
            text: 'Privacy Policy',
            recognizer: _privacyTapRecognizer,
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
