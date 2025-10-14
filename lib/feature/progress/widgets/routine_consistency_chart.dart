import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';

class RoutineConsistencyChart extends StatelessWidget {
  const RoutineConsistencyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressController controller = Get.find<ProgressController>();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Routine Consistency",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff000000),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xffF4F5F0),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Last 2 months",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 13.sp,
                    color: Color(0xff172601),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 300.h,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 12,
              itemBuilder: (context, index) {
                return _buildMonthRow(controller, index);
              },
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: Colors.grey),
              SizedBox(width: 4.w),
              Text(controller.getPreviousMonthName()),
              SizedBox(width: 12.w),
              CircleAvatar(radius: 4, backgroundColor: Color(0xff1A5D1A)),
              SizedBox(width: 4.w),
              Text(controller.getCurrentMonthName()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthRow(ProgressController controller, int index) {
    List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    // Check if this is current or previous month
    bool isCurrentMonth = index == controller.getCurrentMonthIndex();
    bool isPreviousMonth = index == controller.getPreviousMonthIndex();
    bool showGraph = isCurrentMonth || isPreviousMonth;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Month name
          SizedBox(
            width: 40.w,
            child: Text(
              monthNames[index],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: showGraph ? FontWeight.bold : FontWeight.normal,
                color: isCurrentMonth 
                    ? Color(0xff1A5D1A)
                    : isPreviousMonth 
                        ? Colors.grey[700]!
                        : Colors.grey[400]!,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Graph area
          Expanded(
            child: Container(
              height: showGraph ? 90.h : 20.h,
              decoration: showGraph ? BoxDecoration(
                color: Colors.grey.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(8.r),
              ) : null,
              child: showGraph 
                  ? Obx(() {
                      // Build simple two-point lines: x=0 pending, x=1 completed
                      final counts = isCurrentMonth
                          ? controller.getCurrentMonthCounts()
                          : controller.getPreviousMonthCounts();
                      final color = isCurrentMonth ? const Color(0xff1A5D1A) : Colors.grey;
                      final maxY = controller.getMaxRoutineChartY();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 64.h,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                minX: -0.2,
                                maxX: 1.2,
                                minY: 0,
                                maxY: maxY,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, (counts['pending'] ?? 0).toDouble()),
                                      FlSpot(1, (counts['completed'] ?? 0).toDouble()),
                                    ],
                                    isCurved: true,
                                    color: color,
                                    barWidth: 3,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, idx) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: color,
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pending', style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
                              Text('Completed', style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      );
                    })
                  : Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "---",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}