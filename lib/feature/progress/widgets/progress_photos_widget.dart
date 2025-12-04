import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';

class ProgressPhotosWidget extends StatelessWidget {
  const ProgressPhotosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressController controller = Get.put(
      ProgressController(),
      tag: 'progress',
    );
    String formatDate(DateTime? dt) {
      if (dt == null) return '';
      // e.g. 19 Jan 2025
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Before & After",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: controller.toggleShowAll,
                  child: Obx(
                    () => Text(
                      controller.showAll.value ? "Show less" : "Show all",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff485908),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              "Slide to compare your transformation",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff172601),
              ),
            ),
            SizedBox(height: 14.h),
            Divider(thickness: 1),

            // Left Side Photos
            _buildPhotoSection("Left Side", controller.leftProgressImages),
            SizedBox(height: 4.h),

            // Right Side Photos (only show when expanded)
            Obx(
              () => controller.showAll.value
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Right Side",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildPhotoSection(
                          "Right Side",
                          controller.rightProgressImages,
                        ),
                        SizedBox(height: 4.h),

                        // Front Side Photos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Left Side",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        _buildPhotoSection(
                          "Front Side",
                          controller.frontProgressImages,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Font  Side",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              "Before",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "After",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Obx(() {
                              // If server didn't provide parsable dates but we have images,
                              // fall back to showing the current date so the UI is not blank.
                              final earliest =
                                  controller.frontEarliestDate ??
                                  (controller.frontImagesCount > 0
                                      ? DateTime.now()
                                      : null);
                              return Text(
                                earliest != null ? formatDate(earliest) : '',
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff3E4B2C),
                                ),
                              );
                            }),
                            Spacer(),
                            Obx(() {
                              final latest =
                                  controller.frontLatestDate ??
                                  (controller.frontImagesCount > 0
                                      ? DateTime.now()
                                      : null);
                              return Text(
                                latest != null ? formatDate(latest) : '',
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff3E4B2C),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(String title, RxList<String> images) {
    return SizedBox(
      height: 230.h,
      child: Obx(() {
        // Show message if no images captured
        if (images.isEmpty) {
          return SizedBox(
            width: double.infinity,
            height: 220.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 48.sp, color: Colors.grey),
                  SizedBox(height: 8.h),
                  Text(
                    'No $title photos yet',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                  Text(
                    'Take photos to see progress',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Build list of image widgets
        List<Widget> imageWidgets = [];
        for (int i = 0; i < images.length; i++) {
          final imagePath = images[i];
          if (imagePath.isNotEmpty) {
            imageWidgets.add(
              Container(
                width: 99.w,
                height: 220.h,
                margin: EdgeInsets.only(right: 8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _buildProgressImage(imagePath),
                ),
              ),
            );
          }
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageWidgets.length,
          itemBuilder: (context, index) {
            return imageWidgets[index];
          },
        );
      }),
    );
  }

  Widget _buildProgressImage(String imagePath) {
    // Handle empty/null image path
    if (imagePath.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 32,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Remote URL with caching
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xff172601),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: Icon(Icons.error, size: 32, color: Colors.grey[600]),
          ),
        ),
        memCacheWidth: 200, // Resize in memory for better performance
        maxWidthDiskCache: 400, // Limit disk cache size
      );
    } else {
      // Local file
      try {
        final file = File(imagePath);
        if (!file.existsSync()) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 32,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: 200, // Resize for better performance
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.error, size: 32, color: Colors.grey[600]),
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: Icon(Icons.error, size: 32, color: Colors.grey[600]),
          ),
        );
      }
    }
  }
}
