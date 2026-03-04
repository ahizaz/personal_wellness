import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 33.h),

                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: Image(
                              image: AssetImage(IconPath.back),
                              height: 32.h,
                              width: 32.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              IconPath.cross,
                              width: 32.w,
                              height: 32.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Icon
                      Center(
                        child: Image(
                          image: AssetImage(ImagePath.privacypic),
                          width: 48.w,
                          height: 48.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Title
                      Center(
                        child: Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff172601),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Scrollable content
                      SizedBox(
                        height: 380.h,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle('1. Acceptance of Terms'),
                              _sectionBody(
                                'By accessing or using the SKINSpired app, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('2. Use of the App'),
                              _sectionBody(
                                'SKINSpired is designed for personal wellness and skincare tracking. You agree to use the app only for lawful purposes and in accordance with these Terms. You must not use the app in any way that is unlawful, fraudulent, or harmful.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('3. Account Registration'),
                              _sectionBody(
                                'You may be required to create an account to use certain features of the app. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('4. Health Disclaimer'),
                              _sectionBody(
                                'The content provided in this app is for informational purposes only and is not intended as medical advice. Always consult a qualified healthcare professional before making any health-related decisions.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('5. Intellectual Property'),
                              _sectionBody(
                                'All content, trademarks, logos, and intellectual property within the SKINSpired app are owned by SKINSpired and are protected by applicable laws. You may not copy, distribute, or use any content without prior written permission.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('6. User Content'),
                              _sectionBody(
                                'By submitting photos, notes, or other content to the app, you grant SKINSpired a non-exclusive, royalty-free license to use, store, and process that content solely for the purpose of providing the service to you.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('7. Termination'),
                              _sectionBody(
                                'We reserve the right to terminate or suspend your account at our sole discretion, without prior notice, for conduct that we believe violates these Terms of Service or is harmful to other users, us, or third parties.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('8. Changes to Terms'),
                              _sectionBody(
                                'We may update these Terms of Service from time to time. We will notify you of any significant changes by posting the new terms within the app. Your continued use of the app after changes are made constitutes acceptance of the new terms.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('9. Contact Us'),
                              _sectionBody(
                                'If you have any questions about these Terms, please contact us at support@skinspired.com.',
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 33.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'SFPro',
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xff172601),
      ),
    );
  }

  Widget _sectionBody(String body) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Text(
        body,
        style: TextStyle(
          fontFamily: 'SFPro',
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff3E4B2C),
          height: 1.5,
        ),
      ),
    );
  }
}
