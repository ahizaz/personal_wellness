import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                          'Privacy Policy',
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
                              _sectionTitle('1. Information We Collect'),
                              _sectionBody(
                                'We collect information you provide directly to us, such as your name, email address, date of birth, and skin-related data. We also collect information about your usage of the app, including routines, progress photos, and product logs.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('2. How We Use Your Information'),
                              _sectionBody(
                                'We use the information we collect to provide, maintain, and improve the SKINSpired app, to personalize your experience, to send you relevant notifications and updates, and to analyze usage patterns to enhance our features.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('3. Data Storage & Security'),
                              _sectionBody(
                                'Your data is stored securely using Firebase services. We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('4. Progress Photos'),
                              _sectionBody(
                                'Photos you capture within the app are stored locally on your device and, if you choose, may be synced to our secure cloud. We do not share your photos with any third parties without your explicit consent.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('5. Sharing of Information'),
                              _sectionBody(
                                'We do not sell, trade, or rent your personal information to third parties. We may share aggregated, anonymized data with partners for research and analytics. We may disclose information if required by law or to protect our rights.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('6. Third-Party Services'),
                              _sectionBody(
                                'The app uses third-party services such as Firebase (Google) for authentication, push notifications, and data storage. These services have their own privacy policies, and we encourage you to review them.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('7. App Tracking Transparency (iOS)'),
                              _sectionBody(
                                'On iOS devices, we may request permission to track your activity across apps and websites. This is used solely to improve your experience within SKINSpired. You may opt out at any time from your device settings.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('8. Your Rights'),
                              _sectionBody(
                                'You have the right to access, update, or delete your personal data at any time. You can manage your data preferences within the app settings or by contacting us directly at support@skinspired.com.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('9. Children\'s Privacy'),
                              _sectionBody(
                                'SKINSpired is not intended for children under the age of 13. We do not knowingly collect personal information from children. If we learn that a child has provided us with personal information, we will promptly delete it.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('10. Changes to This Policy'),
                              _sectionBody(
                                'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new policy within the app. Your continued use of the app after changes constitute your acceptance.',
                              ),
                              SizedBox(height: 16.h),

                              _sectionTitle('11. Contact Us'),
                              _sectionBody(
                                'If you have any questions or concerns about this Privacy Policy, please contact us at support@skinspired.com.',
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
