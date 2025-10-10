import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressController controller = Get.find<ProgressController>();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Timeline",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff000000),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => controller.refreshTimelineData(),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Color(0xff172601).withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.refresh,
                        size: 16.r,
                        color: Color(0xff172601),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: controller.toggleTimelineShowAll,
                    child: Obx(() => Text(
                      controller.showTimelineAll.value ? "View less" : "View more",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff172601),
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(thickness: 1),
          Obx(
            () => ListView.builder(
              itemCount: controller.showTimelineAll.value 
                  ? controller.progressItems.length 
                  : (controller.progressItems.length > 0 ? 1 : 0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var item = controller.progressItems[index];
                return _buildTimelineItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: _getImageProvider(item['image']),
            radius: 25.r,
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Error loading image: $exception');
            },
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  item['date'],
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item['week'],
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 14.sp,
              color: Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }
}