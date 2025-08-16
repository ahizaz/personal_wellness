import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';

class ProgressDialog extends StatelessWidget {
  final RoutineController controller;

  const ProgressDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false, // Prevent closing with back button
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Full-page blur
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 287.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                  ),
                  child: Obx(() => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 124.w,
                              height: 124.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 124.w,
                                    height: 124.h,
                                    child: CircularProgressIndicator(
                                      value: controller.progress.value / 100,
                                      strokeWidth: 6.w,
                                      backgroundColor: Colors.grey[300],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(Color(0xff485908)),
                                    ),
                                  ),
                                  if (controller.progress.value < 100)
                                    Text(
                                      '${controller.progress.value}%',
                                      style: TextStyle(
                                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                                    ),
                                  if (controller.progress.value == 100)
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff0B8E5E),
                                        border: Border.all(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      child: Icon(Icons.check, color: Colors.white, size: 40.sp),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            controller.progressMessage.value,
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff172601),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, RoutineController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return ProgressDialog(controller: controller);
      },
    );
  }
}