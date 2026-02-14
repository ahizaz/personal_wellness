import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HealthDisclaimerDialog {
  static void show(BuildContext context, VoidCallback onAccept) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: const Color(0xff485908),
                      size: 28.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Health & Wellness Notice',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff485908),
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Important Information',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff333333),
                    fontFamily: 'SFPro',
                  ),
                ),
                SizedBox(height: 8.h),
                _buildDisclaimerPoint(
                  '• This app is designed for educational and tracking purposes only.',
                ),
                _buildDisclaimerPoint(
                  '• This app does NOT provide medical advice, diagnosis, or treatment.',
                ),
                _buildDisclaimerPoint(
                  '• Always consult with qualified healthcare professionals for medical concerns.',
                ),
                _buildDisclaimerPoint(
                  '• Do not use this app as a substitute for professional medical advice.',
                ),
                _buildDisclaimerPoint(
                  '• Results may vary and are not guaranteed.',
                ),
                _buildDisclaimerPoint(
                  '• In case of emergency, contact your doctor or emergency services immediately.',
                ),
                SizedBox(height: 16.h),
                Text(
                  'Privacy Notice',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff333333),
                    fontFamily: 'SFPro',
                  ),
                ),
                SizedBox(height: 8.h),
                _buildDisclaimerPoint(
                  '• Your data is stored securely and is never shared without your consent.',
                ),
                _buildDisclaimerPoint(
                  '• You can delete your account and data at any time.',
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          Get.back(); // Go back to previous screen
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: const BorderSide(color: Color(0xff485908)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Decline',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff485908),
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onAccept();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff485908),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'I Understand & Accept',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDisclaimerPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff666666),
          fontFamily: 'SFPro',
          height: 1.4,
        ),
      ),
    );
  }
}
