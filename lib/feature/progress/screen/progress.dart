
// import 'dart:io';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:personal_wellness/feature/today/screen/go_picture.dart';
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:personal_wellness/core/utils/constants/image_path.dart';
// import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';

// class ProgressData extends StatelessWidget {
//   const ProgressData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ProgressController controller = Get.put(ProgressController());

//     // Function to generate and export PDF
//     Future<void> exportToPDF() async {
//       final pdf = pw.Document();
//       try {
//         // Load images for Before & After section
//         final beforeImage = await imageFromAssetBundle(ImagePath.beforeafterimage1);
//         final afterImage = await imageFromAssetBundle(ImagePath.beforeafterimage2);
//         final bambooImage = await imageFromAssetBundle(ImagePath.bamboo);
//         final afterImage2 = await imageFromAssetBundle(ImagePath.beforeafterimage3);
//         final progressImage = await imageFromAssetBundle(ImagePath.progressimageback);

//         // Add a page to the PDF
//         pdf.addPage(
//           pw.MultiPage(
//             pageFormat: PdfPageFormat.a4,
//             margin: pw.EdgeInsets.all(16),
//             build: (pw.Context context) {
//               return [
//               // Title
//               pw.Text(
//                 "Progress & History",
//                 style: pw.TextStyle(
//                   fontSize: 20,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 16),

//               // Timeline Section
//               pw.Text(
//                 "Timeline",
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Divider(),
//               pw.SizedBox(height: 8),
//               ...controller.progressItems.map((item) {
//                 return pw.Padding(
//                   padding: pw.EdgeInsets.symmetric(vertical: 8),
//                   child: pw.Row(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         "${item['title']} - ${item['date']} - ${item['week']}",
//                         style: pw.TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               pw.SizedBox(height: 16),

//               // Before & After Section
//               pw.Text(
//                 "Before & After",
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Text(
//                 "Slide to compare your transformation",
//                 style: pw.TextStyle(fontSize: 12),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Divider(),
//               pw.SizedBox(height: 8),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Image(beforeImage, width: 100, height: 200),
//                   pw.Image(bambooImage, width: 20, height: 200),
//                   pw.Image(afterImage, width: 100, height: 200),
//                   pw.Image(afterImage2, width: 100, height: 200),
//                 ],
//               ),
//               pw.SizedBox(height: 8),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text("Before - 15 Jan 2025", style: pw.TextStyle(fontSize: 12)),
//                   pw.Text("After - 15 Mar 2025", style: pw.TextStyle(fontSize: 12)),
//                 ],
//               ),
//               pw.SizedBox(height: 16),

//               // Update Progress Section
//               pw.Text(
//                 "Update your Progress",
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Text(
//                 "Take your progress photo to track your skin journey",
//                 style: pw.TextStyle(fontSize: 12),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Image(progressImage, width: 100, height: 100),
//               pw.SizedBox(height: 16),

//               // Routine Consistency Section
//               pw.Text(
//                 "Routine Consistency",
//                 style: pw.TextStyle(
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 8),
//               pw.Text(
//                 "Last 2 months",
//                 style: pw.TextStyle(fontSize: 12),
//               ),
//               pw.SizedBox(height: 8),
//               // Note: For the chart, you can add a text-based summary or capture the chart as an image
//               pw.Text(
//                 "Jan Data: ${controller.janData.map((e) => '(${e.x}, ${e.y})').join(', ')}",
//                 style: pw.TextStyle(fontSize: 12),
//               ),
//               pw.Text(
//                 "Feb Data: ${controller.febData.map((e) => '(${e.x}, ${e.y})').join(', ')}",
//                 style: pw.TextStyle(fontSize: 12),
//               ),
//               ];
//             },
//           ),
//         );

//         // Try showing print preview (allows Save as PDF on many devices)
//         await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//       } catch (e) {
//         Get.snackbar('Print preview failed', e.toString());
//         try {
//           // Fallback to share if print preview isn't available on emulator
//           await Printing.sharePdf(bytes: await pdf.save(), filename: 'progress_report.pdf');
//         } catch (e2) {
//           Get.snackbar('Share failed', e2.toString());
//           try {
//             // Final fallback: save to app documents and open
//             final dir = await getApplicationDocumentsDirectory();
//             final filePath = '${dir.path}/progress_report.pdf';
//             final bytes = await pdf.save();
//             final file = await File(filePath).writeAsBytes(bytes, flush: true);
//             Get.snackbar('Saved', 'PDF saved to: $filePath');
//             await OpenFilex.open(file.path);
//           } catch (e3) {
//             Get.snackbar('Open failed', e3.toString());
//           }
//         }
//       }
//     }

//     return Scaffold(
//       backgroundColor: Color(0xffEDEEE6),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 7.h),
//                 Center(
//                   child: Text(
//                     "Progress & history",
//                     style: TextStyle(
//                       fontFamily: "SFPro",
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xff000000),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   padding: EdgeInsets.all(16.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: .8),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Timeline",
//                             style: TextStyle(
//                               fontFamily: "SFPro",
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                           Text(
//                             "View all",
//                             style: TextStyle(
//                               fontFamily: "SFPro",
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff172601),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 14.h),
//                       Divider(thickness: 1),
//                       Obx(
//                         () => ListView.builder(
//                           itemCount: controller.progressItems.length,
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             var item = controller.progressItems[index];
//                             return Padding(
//                               padding: EdgeInsets.symmetric(vertical: 10.h),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundImage: AssetImage(item['image']),
//                                     radius: 25.r,
//                                   ),
//                                   SizedBox(width: 15.w),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           item['title'],
//                                           style: TextStyle(
//                                             fontFamily: "SFPro",
//                                             fontSize: 16.sp,
//                                             fontWeight: FontWeight.w600,
//                                             color: Color(0xff000000),
//                                           ),
//                                         ),
//                                         SizedBox(height: 5.h),
//                                         Text(
//                                           item['date'],
//                                           style: TextStyle(
//                                             fontFamily: "SFPro",
//                                             fontSize: 14.sp,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     item['week'],
//                                     style: TextStyle(
//                                       fontFamily: "SFPro",
//                                       fontSize: 14.sp,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.8),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Before & After",
//                           style: TextStyle(
//                             fontFamily: "SFPro",
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xff172601),
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           "Slide to compare your transformation",
//                           style: TextStyle(
//                             fontFamily: "SFPro",
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xff172601),
//                           ),
//                         ),
//                         SizedBox(height: 14.h),
//                         Divider(thickness: 1),
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 99.w,
//                               height: 220.h,
//                               child: Image(
//                                 image: AssetImage(ImagePath.beforeafterimage1),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(width: 2.w),
//                             SizedBox(
//                               width: 99.w,
//                               height: 220.h,
//                               child: Image(
//                                 image: AssetImage(ImagePath.beforeafterimage2),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 14.w,
//                               height: 230.h,
//                               child: Image(
//                                 image: AssetImage(ImagePath.bamboo),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 125.w,
//                               height: 220.h,
//                               child: Image(
//                                 image: AssetImage(ImagePath.beforeafterimage3),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             Text(
//                               "Before",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff172601),
//                               ),
//                             ),
//                             Spacer(),
//                             Text(
//                               "After",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff172601),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             Text(
//                               "15 Jan 2025",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff172601),
//                               ),
//                             ),
//                             Spacer(),
//                             Text(
//                               "15 Mar 2025",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff172601),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   width: double.infinity,
//                   height: 180.h,
//                   decoration: BoxDecoration(
//                     color: Color(0xffFFFFFF),
//                     borderRadius: BorderRadius.circular(6.r),
//                   ),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Update your Progress",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xff172601),
//                               ),
//                             ),
//                             SizedBox(height: 8.h),
//                             Text(
//                               "Take your progress photo to\ntrack your skin journey",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xff3E4B2C),
//                               ),
//                             ),
//                             SizedBox(height: 16.h),
//                             InkWell(
//                               onTap: (){
//                                 Get.to(()=>GoPicture());
//                               },
//                               child: Container(
//                                 width: 141.w,
//                                 height: 48.h,
//                                 decoration: BoxDecoration(
//                                   color: Color(0xff172601),
//                                   borderRadius: BorderRadius.circular(999.r),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "Take a photo",
//                                     style: TextStyle(
//                                       fontFamily: "SFPro",
//                                       fontSize: 17.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xffFFFFFF),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Spacer(),
//                       SizedBox(
//                         width: 110,
//                         height: double.infinity,
//                         child: Image(
//                           image: AssetImage(ImagePath.progressimageback),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   padding: EdgeInsets.all(16.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.8),
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Routine Consistency",
//                             style: TextStyle(
//                               fontFamily: "SFPro",
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                             decoration: BoxDecoration(
//                               color: Color(0xffF4F5F0),
//                               borderRadius: BorderRadius.circular(6.r),
//                             ),
//                             child: Text(
//                               "Last 2 months",
//                               style: TextStyle(
//                                 fontFamily: "SFPro",
//                                 fontSize: 13.sp,
//                                 color: Color(0xff172601),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16.h),
//                       SizedBox(
//                         height: 200.h,
//                         child: Obx(
//                           () => LineChart(
//                             LineChartData(
//                               gridData: FlGridData(show: false),
//                               titlesData: FlTitlesData(
//                                 leftTitles: AxisTitles(
//                                   sideTitles: SideTitles(
//                                     showTitles: true,
//                                     interval: 1,
//                                     getTitlesWidget: (value, meta) {
//                                       switch (value.toInt()) {
//                                         case 0:
//                                           return Text("Jan", style: TextStyle(fontSize: 12.sp));
//                                         case 1:
//                                           return Text("Feb", style: TextStyle(fontSize: 12.sp));
//                                         case 2:
//                                           return Text("Mar", style: TextStyle(fontSize: 12.sp));
//                                         case 3:
//                                           return Text("Apr", style: TextStyle(fontSize: 12.sp));
//                                         case 4:
//                                           return Text("May", style: TextStyle(fontSize: 12.sp));
//                                         case 5:
//                                           return Text("Jun", style: TextStyle(fontSize: 12.sp));
//                                         case 6:
//                                           return Text("Jul", style: TextStyle(fontSize: 12.sp));
//                                         case 7:
//                                           return Text("Aug", style: TextStyle(fontSize: 12.sp));
//                                         case 8:
//                                           return Text("Sep", style: TextStyle(fontSize: 12.sp));
//                                         case 9:
//                                           return Text("Oct", style: TextStyle(fontSize: 12.sp));
//                                         case 10:
//                                           return Text("Nov", style: TextStyle(fontSize: 12.sp));
//                                         case 11:
//                                           return Text("Dec", style: TextStyle(fontSize: 12.sp));
//                                       }
//                                       return const SizedBox.shrink();
//                                     },
//                                   ),
//                                 ),
//                                 bottomTitles: AxisTitles(
//                                   sideTitles: SideTitles(showTitles: false),
//                                 ),
//                                 topTitles: AxisTitles(
//                                   sideTitles: SideTitles(showTitles: false),
//                                 ),
//                                 rightTitles: AxisTitles(
//                                   sideTitles: SideTitles(showTitles: false),
//                                 ),
//                               ),
//                               borderData: FlBorderData(show: false),
//                               lineBarsData: [
//                                 LineChartBarData(
//                                   spots: controller.janData,
//                                   isCurved: true,
//                                   color: Colors.grey,
//                                   barWidth: 2,
//                                   dotData: FlDotData(show: true),
//                                 ),
//                                 LineChartBarData(
//                                   spots: controller.febData,
//                                   isCurved: true,
//                                   color: Color(0xff1A5D1A),
//                                   barWidth: 2,
//                                   dotData: FlDotData(show: true),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Row(
//                         children: [
//                           CircleAvatar(radius: 4, backgroundColor: Colors.grey),
//                           SizedBox(width: 4.w),
//                           Text("Jan"),
//                           SizedBox(width: 12.w),
//                           CircleAvatar(radius: 4, backgroundColor: Color(0xff1A5D1A)),
//                           SizedBox(width: 4.w),
//                           Text("Feb"),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 24.h),
//                 Container(
//                   width: double.infinity,
//                   height: 48.h,
//                   decoration: BoxDecoration(
//                     color: Color(0xff172601),
//                     borderRadius: BorderRadius.circular(999.r),
//                   ),
//                   child: InkWell(
//                     onTap: exportToPDF, // Call the PDF export function
//                     child: Center(
//                       child: Text(
//                         "Export as PDF",
//                         style: TextStyle(
//                           fontFamily: "SFPro",
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xffFFFFFF),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 29.h),
//                 Center(
//                   child: Text(
//                     "Share Progress",
//                     style: TextStyle(
//                       fontFamily: "SFPro",
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xff121221),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 43.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper function to load image from assets
//   Future<pw.ImageProvider> imageFromAssetBundle(String path) async {
//     final byteData = await rootBundle.load(path);
//     return pw.MemoryImage(byteData.buffer.asUint8List());
//   }
// }
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:personal_wellness/feature/today/screen/go_picture.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';

class ProgressData extends StatelessWidget {
  const ProgressData({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressController controller = Get.put(ProgressController());

    // Function to generate and export PDF
    Future<void> exportToPDF() async {
      final pdf = pw.Document();
      try {
        // Load images for Before & After section
        final beforeImage = await imageFromAssetBundle(ImagePath.beforeafterimage1);
        final afterImage = await imageFromAssetBundle(ImagePath.beforeafterimage2);
        final bambooImage = await imageFromAssetBundle(ImagePath.bamboo);
        final afterImage2 = await imageFromAssetBundle(ImagePath.beforeafterimage3);
        final progressImage = await imageFromAssetBundle(ImagePath.progressimageback);

        // Add a page to the PDF
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(16),
            build: (pw.Context context) {
              return [
              // Title
              pw.Text(
                "Progress & History",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),

              // Timeline Section
              pw.Text(
                "Timeline",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.SizedBox(height: 8),
              ...controller.progressItems.map((item) {
                return pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${item['title']} - ${item['date']} - ${item['week']}",
                        style: pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
              pw.SizedBox(height: 16),

              // Before & After Section
              pw.Text(
                "Before & After",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Slide to compare your transformation",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(beforeImage, width: 100, height: 200),
                  pw.Image(bambooImage, width: 20, height: 200),
                  pw.Image(afterImage, width: 100, height: 200),
                  pw.Image(afterImage2, width: 100, height: 200),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Before - 15 Jan 2025", style: pw.TextStyle(fontSize: 12)),
                  pw.Text("After - 15 Mar 2025", style: pw.TextStyle(fontSize: 12)),
                ],
              ),
              pw.SizedBox(height: 16),

              // Update Progress Section
              pw.Text(
                "Update your Progress",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Take your progress photo to track your skin journey",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 8),
              pw.Image(progressImage, width: 100, height: 100),
              pw.SizedBox(height: 16),

              // Routine Consistency Section
              pw.Text(
                "Routine Consistency",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Last 2 months",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 8),
              // Note: For the chart, you can add a text-based summary or capture the chart as an image
              pw.Text(
                "Jan Data: ${controller.janData.map((e) => '(${e.x}, ${e.y})').join(', ')}",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                "Feb Data: ${controller.febData.map((e) => '(${e.x}, ${e.y})').join(', ')}",
                style: pw.TextStyle(fontSize: 12),
              ),
              ];
            },
          ),
        );

        // Try showing print preview (allows Save as PDF on many devices)
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
      } catch (e) {
        Get.snackbar('Print preview failed', e.toString());
        try {
          // Fallback to share if print preview isn't available on emulator
          await Printing.sharePdf(bytes: await pdf.save(), filename: 'progress_report.pdf');
        } catch (e2) {
          Get.snackbar('Share failed', e2.toString());
          try {
            // Final fallback: save to app documents and open
            final dir = await getApplicationDocumentsDirectory();
            final filePath = '${dir.path}/progress_report.pdf';
            final bytes = await pdf.save();
            final file = await File(filePath).writeAsBytes(bytes, flush: true);
            Get.snackbar('Saved', 'PDF saved to: $filePath');
            await OpenFilex.open(file.path);
          } catch (e3) {
            Get.snackbar('Open failed', e3.toString());
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 7.h),
                Center(
                  child: Text(
                    "Progress & history",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
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
                          Text(
                            "View all",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Divider(thickness: 1),
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.progressItems.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = controller.progressItems[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(item['image']),
                                    radius: 25.r,
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
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
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
                        Text("Show all",style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff485908)
                        ),)
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

                        ////Right Side
                           Row(
                          children: [
                            SizedBox(
                              width: 99.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage1),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            SizedBox(
                              width: 99.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage2),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 14.w,
                              height: 230.h,
                              child: Image(
                                image: AssetImage(ImagePath.bamboo),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 125.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage3),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),////right side
                        SizedBox(height: 4.h),
                        Text("Right Side",style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff172601)

                        ),),
                        SizedBox(height: 16.h),
                     
                    ///leftSIde 
                          Row(
                          children: [
                            SizedBox(
                              width: 99.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage1),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            SizedBox(
                              width: 99.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage2),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 14.w,
                              height: 230.h,
                              child: Image(
                                image: AssetImage(ImagePath.bamboo),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 125.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage3),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                           Text("Right Side",style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff172601)

                        ),),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 150.h,
                                child: Image(
                                  image: AssetImage(ImagePath.beforeafterimage2), // Replace with your actual left side before image path
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 14.w,
                              height: 160.h,
                              child: Image(
                                image: AssetImage(ImagePath.bamboo),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 150.h,
                                child: Image(
                                  image: AssetImage(ImagePath.beforeafterimage3), 
                                  fit: BoxFit.cover,
                                ),
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
                            Text(
                              "15 Jan 2025",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "15 Mar 2025",
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
                        Text(
                          "Front",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff172601),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 99.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage1),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            SizedBox(
                              width: 99.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage2),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 14.w,
                              height: 230.h,
                              child: Image(
                                image: AssetImage(ImagePath.bamboo),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 125.w,
                              height: 220.h,
                              child: Image(
                                image: AssetImage(ImagePath.beforeafterimage3),
                                fit: BoxFit.cover,
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
                            Text(
                              "19 Jan 2025",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "15 Mar 2025",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172601),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Update your Progress",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff172601),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Take your progress photo to\ntrack your skin journey",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff3E4B2C),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            InkWell(
                              onTap: (){
                                Get.to(()=>GoPicture());
                              },
                              child: Container(
                                width: 141.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Color(0xff172601),
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "Take a photo",
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 110,
                        height: double.infinity,
                        child: Image(
                          image: AssetImage(ImagePath.progressimageback),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
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
                      SizedBox(
                        height: 200.h,
                        child: Obx(
                          () => LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return Text("Jan", style: TextStyle(fontSize: 12.sp));
                                        case 1:
                                          return Text("Feb", style: TextStyle(fontSize: 12.sp));
                                        case 2:
                                          return Text("Mar", style: TextStyle(fontSize: 12.sp));
                                        case 3:
                                          return Text("Apr", style: TextStyle(fontSize: 12.sp));
                                        case 4:
                                          return Text("May", style: TextStyle(fontSize: 12.sp));
                                        case 5:
                                          return Text("Jun", style: TextStyle(fontSize: 12.sp));
                                        case 6:
                                          return Text("Jul", style: TextStyle(fontSize: 12.sp));
                                        case 7:
                                          return Text("Aug", style: TextStyle(fontSize: 12.sp));
                                        case 8:
                                          return Text("Sep", style: TextStyle(fontSize: 12.sp));
                                        case 9:
                                          return Text("Oct", style: TextStyle(fontSize: 12.sp));
                                        case 10:
                                          return Text("Nov", style: TextStyle(fontSize: 12.sp));
                                        case 11:
                                          return Text("Dec", style: TextStyle(fontSize: 12.sp));
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: controller.janData,
                                  isCurved: true,
                                  color: Colors.grey,
                                  barWidth: 2,
                                  dotData: FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: controller.febData,
                                  isCurved: true,
                                  color: Color(0xff1A5D1A),
                                  barWidth: 2,
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                          SizedBox(width: 4.w),
                          Text("Jan"),
                          SizedBox(width: 12.w),
                          CircleAvatar(radius: 4, backgroundColor: Color(0xff1A5D1A)),
                          SizedBox(width: 4.w),
                          Text("Feb"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Color(0xff172601),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: InkWell(
                    onTap: exportToPDF, // Call the PDF export function
                    child: Center(
                      child: Text(
                        "Export as PDF",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 29.h),
                Center(
                  child: Text(
                    "Share Progress",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff121221),
                    ),
                  ),
                ),
                SizedBox(height: 43.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to load image from assets
  Future<pw.ImageProvider> imageFromAssetBundle(String path) async {
    final byteData = await rootBundle.load(path);
    return pw.MemoryImage(byteData.buffer.asUint8List());
  }
}