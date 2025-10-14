
import 'dart:io';
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
import 'package:http/http.dart' as http;
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';
import 'package:personal_wellness/feature/progress/widgets/timeline_widget.dart';
import 'package:personal_wellness/feature/progress/widgets/progress_photos_widget.dart';
import 'package:personal_wellness/feature/progress/widgets/routine_consistency_chart.dart';

class ProgressData extends StatefulWidget {
  const ProgressData({super.key});

  @override
  State<ProgressData> createState() => _ProgressDataState();
}

class _ProgressDataState extends State<ProgressData> with WidgetsBindingObserver, RouteAware {
  late ProgressController controller;
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProgressController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when user returns to this screen from another screen
    controller.getAllPhotoProgress();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Automatically refresh when app comes to foreground
      controller.getAllPhotoProgress();
    }
  }



  @override
  Widget build(BuildContext context) {

    // Function to generate and export PDF
    Future<void> exportToPDF() async {
      final pdf = pw.Document();
      try {
        // Load images dynamically (fallback to assets if network not available)
        final leftUrl = controller.getLatestLeftImage();
        final rightUrl = controller.getLatestRightImage();
        final frontUrl = controller.getLatestFrontImage();

        final leftImage = await networkImageProvider(leftUrl) ?? await imageFromAssetBundle(ImagePath.beforeafterimage1);
        final rightImage = await networkImageProvider(rightUrl) ?? await imageFromAssetBundle(ImagePath.beforeafterimage1);
        final frontImage = await networkImageProvider(frontUrl) ?? await imageFromAssetBundle(ImagePath.beforeafterimage1);
        final bambooImage = await imageFromAssetBundle(ImagePath.bamboo);
        final progressImage = await imageFromAssetBundle(ImagePath.progressimageback);

        final prevCounts = controller.getPreviousMonthCounts();
        final currCounts = controller.getCurrentMonthCounts();

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
                  pw.Image(leftImage, width: 100, height: 160, fit: pw.BoxFit.cover),
                  pw.Image(bambooImage, width: 20, height: 160, fit: pw.BoxFit.cover),
                  pw.Image(frontImage, width: 100, height: 160, fit: pw.BoxFit.cover),
                  pw.Image(rightImage, width: 100, height: 160, fit: pw.BoxFit.cover),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Left", style: pw.TextStyle(fontSize: 12)),
                  pw.Text("Front", style: pw.TextStyle(fontSize: 12)),
                  pw.Text("Right", style: pw.TextStyle(fontSize: 12)),
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
              pw.Text(
                "${controller.getPreviousMonthName()} - Completed: ${prevCounts['completed']}, Pending: ${prevCounts['pending']}",
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                "${controller.getCurrentMonthName()} - Completed: ${currCounts['completed']}, Pending: ${currCounts['pending']}",
                style: pw.TextStyle(fontSize: 12),
              ),
              ];
            },
          ),
        );

        // Let user choose what to do with the PDF
        if (!mounted) return;
        await showModalBottomSheet(
          context: context,
          builder: (_) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Preview / Print'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
                    },
                  ),
                  ListTile(
                    title: const Text('Share PDF'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await Printing.sharePdf(bytes: await pdf.save(), filename: 'progress_report.pdf');
                    },
                  ),
                  ListTile(
                    title: const Text('Save PDF'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      try {
                        final dir = await getApplicationDocumentsDirectory();
                        final ts = DateTime.now().millisecondsSinceEpoch;
                        final filePath = '${dir.path}/progress_report_$ts.pdf';
                        final file = await File(filePath).writeAsBytes(await pdf.save(), flush: true);
                        Get.snackbar('Saved', 'PDF saved to: $filePath');
                        await OpenFilex.open(file.path);
                      } catch (e) {
                        Get.snackbar('Save failed', e.toString());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
        Get.snackbar('Print preview failed', e.toString());
        // Last resort: save locally
        try {
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
                const TimelineWidget(),
                SizedBox(height: 16.h),
                const ProgressPhotosWidget(),
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
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
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
                const RoutineConsistencyChart(),
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

                SizedBox(height: 16.h),
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

  // Load image from network (for PDF)
  Future<pw.ImageProvider?> networkImageProvider(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        return pw.MemoryImage(resp.bodyBytes);
      }
    } catch (_) {}
    return null;
  }
}