
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

  // Helper method to build progress image widget (handles both local files and remote URLs)
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
      // Remote URL
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.error,
                size: 32,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      );
    } else {
      // Local file - add extra safety checks
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
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.error,
                  size: 32,
                  color: Colors.grey[600],
                ),
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
            child: Icon(
              Icons.error,
              size: 32,
              color: Colors.grey[600],
            ),
          ),
        );
      }
    }
  }

  // Helper method to get appropriate image provider (asset or network)
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Function to generate and export PDF
    Future<void> exportToPDF() async {
      final pdf = pw.Document();
      try {
        // Load images for Before & After section
        final beforeImage = await imageFromAssetBundle(ImagePath.beforeafterimage1);
        final afterImage = await imageFromAssetBundle(ImagePath.beforeafterimage1);
        final bambooImage = await imageFromAssetBundle(ImagePath.bamboo);
        final afterImage2 = await imageFromAssetBundle(ImagePath.beforeafterimage1);
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
                          Row(
                            children: [
                              InkWell(
                                onTap: () => controller.refreshTimelineData(),
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: Color(0xff172601).withValues(alpha: 0.1),
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
                    color: Colors.white.withValues(alpha: 0.8),
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
                          child: Obx(() => Text(
                            controller.showAll.value ? "Show less" : "Show all",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff485908)
                            ),
                          )),
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

                        ////Left Side - Horizontal Scrollable
                        SizedBox(
                          height: 230.h,
                          child: Obx(() {
                            // Show message if no images captured
                            if (controller.leftProgressImages.isEmpty) {
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
                                        'No left side photos yet',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Take photos to see progress',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            // Build list of image widgets
                            List<Widget> images = [];
                            for (int i = 0; i < controller.leftProgressImages.length; i++) {
                              final imagePath = controller.leftProgressImages[i];
                              if (imagePath.isNotEmpty) {
                                images.add(
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
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return images[index];
                              },
                            );
                          }),
                        ),////right side
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Right Side",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff172601)
                            ),),
                          ],
                        ),
                        SizedBox(height: 16.h),
                     
                    ///Right Side 
                    Obx(() => controller.showAll.value ? Column(
                      children: [
                          // Right Side - Horizontal Scrollable
                          SizedBox(
                            height: 230.h,
                            child: Obx(() {
                              // Show message if no images captured
                              if (controller.rightProgressImages.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  height: 220.h,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt, size: 48.sp, color: Colors.grey),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'No right side photos yet',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Take photos to see progress',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              
                              // Build list of image widgets
                              List<Widget> images = [];
                              for (int i = 0; i < controller.rightProgressImages.length; i++) {
                                final imagePath = controller.rightProgressImages[i];
                                if (imagePath.isNotEmpty) {
                                  images.add(
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
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return images[index];
                                },
                              );
                            }),
                          ),
                        SizedBox(height: 4.h),
                        
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

                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Front Side",
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
                        // Front Side - Horizontal Scrollable
                        SizedBox(
                          height: 230.h,
                          child: Obx(() {
                            // Show message if no images captured
                            if (controller.frontProgressImages.isEmpty) {
                              return Container(
                                width: double.infinity,
                                height: 220.h,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, size: 48.sp, color: Colors.grey),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'No front photos yet',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Take photos to see progress',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            // Build list of image widgets
                            List<Widget> images = [];
                            for (int i = 0; i < controller.frontProgressImages.length; i++) {
                              final imagePath = controller.frontProgressImages[i];
                              if (imagePath.isNotEmpty) {
                                images.add(
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
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return images[index];
                              },
                            );
                          }),
                        ),
                                             Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      "Font",
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
                            Text(
                              "19 Jan 2025",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff3E4B2C),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "15 Mar 2025",
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff3E4B2C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ) : SizedBox()),
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
}