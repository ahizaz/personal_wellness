import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:personal_wellness/core/urls/urls.dart';

class ProgressController extends GetxController{
  var progressItems = <Map<String,dynamic>>[].obs;
   var janData = <FlSpot>[].obs;
  var febData = <FlSpot>[].obs;
  var marData = <FlSpot>[].obs;
  var aprData = <FlSpot>[].obs;
  var mayData = <FlSpot>[].obs;
  var junData = <FlSpot>[].obs;
  var julData = <FlSpot>[].obs;
  var augData = <FlSpot>[].obs;
  var sepData = <FlSpot>[].obs;
  var octData = <FlSpot>[].obs;
  var novData = <FlSpot>[].obs;
  var decData = <FlSpot>[].obs;
  var showAll = false.obs;
  var showTimelineAll = false.obs;
  
  // Store captured progress images
  var leftProgressImages = <String>[].obs;  // Left side images
  var rightProgressImages = <String>[].obs; // Right side images  
  var frontProgressImages = <String>[].obs; // Front images

  // Store corresponding createdAt timestamps (nullable when unknown)
  var leftProgressDates = <DateTime?>[].obs;
  var rightProgressDates = <DateTime?>[].obs;
  var frontProgressDates = <DateTime?>[].obs;
  
  // Loading state for images
  var isLoadingImages = false.obs;

  // Routine consistency chart raw data from API: {"MM-YYYY": {"pending": x, "completed": y}}
  final RxMap<String, dynamic> routineChartRaw = <String, dynamic>{}.obs;
  final RxBool isLoadingRoutineChart = false.obs;
  @override
  void onInit() {
   
    super.onInit();
    loadData();
    loadGraphData();
    getAllPhotoProgress(showLoading: true); // Load photo progress from API
    fetchRoutineChartData();
  }
  
  // Load timeline data from API
  Future<void> loadData() async {
    try {
      EasyLoading.show(status: "Loading timeline...", maskType: EasyLoadingMaskType.black);
      
      final accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.showError("Please login again");
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.photoProgressTimeline),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"] != null && data["data"]["result"] != null) {
          List<dynamic> results = data["data"]["result"];
          
          // Get latest 3 items (reversed to show most recent first)
          if (results.length > 3) {
            results = results.reversed.take(3).toList();
          } else {
            results = results.reversed.toList();
          }
          
          // Transform API data to match expected format
          progressItems.value = results.map((item) => {
            'title': item["label"] ?? "Progress Photo",
            'date': item["date"] ?? "",
            'week': item["label"] ?? "Day 1", // Use label as week
            'image': "${Urls.imageurl}${item["image"]}", // Full image URL
            'type': item["type"] ?? "",
            'id': item["_id"] ?? "",
          }).toList().cast<Map<String, dynamic>>();
          
          debugPrint("Timeline data loaded: ${progressItems.length} items");
          EasyLoading.dismiss();
        } else {
          debugPrint("Timeline API returned success=false or no data");
          // Load fallback static data
          _loadFallbackData();
          EasyLoading.showError("No timeline data available");
        }
      } else {
        debugPrint("Timeline API Error - Status: ${response.statusCode}");
        // Load fallback static data
        _loadFallbackData();
        EasyLoading.showError("Failed to load timeline data");
      }
    } catch (e) {
      debugPrint("Error loading timeline data: $e");
      // Load fallback static data
      _loadFallbackData();
      EasyLoading.showError("Error loading timeline data");
    }
  }

  // ================= Routine Consistency Chart (API) =================
  Future<void> fetchRoutineChartData() async {
    try {
      isLoadingRoutineChart.value = true;
      final accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.showError("Please login again");
        isLoadingRoutineChart.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.routineconsistencyChart),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is Map && body['success'] == true && body['data'] is Map) {
          routineChartRaw.assignAll(Map<String, dynamic>.from(body['data'] as Map));
        } else {
          debugPrint('Routine chart API returned unexpected payload: ${response.body}');
        }
      } else {
        debugPrint('Routine chart API error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Routine chart fetch error: $e');
    } finally {
      isLoadingRoutineChart.value = false;
    }
  }

  // Parse key like "10-2025" to month index (0-11) and year
  ({int monthIndex, int year}) _parseMonthYearKey(String key) {
    try {
      final parts = key.split('-');
      if (parts.length == 2) {
        final month = int.tryParse(parts[0]) ?? 0; // 1-12
        final year = int.tryParse(parts[1]) ?? DateTime.now().year;
        return (monthIndex: (month - 1).clamp(0, 11), year: year);
      }
    } catch (_) {}
    return (monthIndex: DateTime.now().month - 1, year: DateTime.now().year);
  }

  // Get counts for a given month index and (optional) year preference
  Map<String, int> getCountsForMonthIndex(int monthIndex, {int? preferYear}) {
    int? bestYear;
    Map<String, int> result = { 'pending': 0, 'completed': 0 };
    routineChartRaw.forEach((k, v) {
      final parsed = _parseMonthYearKey(k);
      if (parsed.monthIndex == monthIndex) {
        if (preferYear == null || parsed.year == preferYear) {
          bestYear = parsed.year;
          final map = (v is Map) ? v : <String, dynamic>{};
          result = {
            'pending': (map['pending'] is num) ? (map['pending'] as num).toInt() : 0,
            'completed': (map['completed'] is num) ? (map['completed'] as num).toInt() : 0,
          };
        }
      }
    });
    // If not found with preferYear, try any year
    if (bestYear == null && preferYear != null) {
      routineChartRaw.forEach((k, v) {
        final parsed = _parseMonthYearKey(k);
        if (parsed.monthIndex == monthIndex) {
          final map = (v is Map) ? v : <String, dynamic>{};
          result = {
            'pending': (map['pending'] is num) ? (map['pending'] as num).toInt() : 0,
            'completed': (map['completed'] is num) ? (map['completed'] as num).toInt() : 0,
          };
        }
      });
    }
    return result;
  }

  Map<String, int> getCurrentMonthCounts() {
    final now = DateTime.now();
    return getCountsForMonthIndex(getCurrentMonthIndex(), preferYear: now.year);
  }

  Map<String, int> getPreviousMonthCounts() {
    final now = DateTime.now();
    // If previous month is December, prefer previous year
    final prevMonthIndex = getPreviousMonthIndex();
    final preferYear = (getCurrentMonthIndex() == 0) ? now.year - 1 : now.year;
    return getCountsForMonthIndex(prevMonthIndex, preferYear: preferYear);
  }

  double getMaxRoutineChartY() {
    final c = getCurrentMonthCounts();
    final p = getPreviousMonthCounts();
    final maxVal = [c['pending'] ?? 0, c['completed'] ?? 0, p['pending'] ?? 0, p['completed'] ?? 0].reduce((a, b) => a > b ? a : b);
    // Ensure a minimum headroom
    return (maxVal <= 0) ? 5 : (maxVal + 1).toDouble();
  }
  
  // Fallback static data in case API fails
  void _loadFallbackData() {
    progressItems.value = [
      {
        'title': 'Day 1 Starting point',
        'date': '15 Jan,2025',
        'week': 'Week 1',
        'image': "assets/icons/progresshistory.png",
      },
      {
        'title': 'Week 2 Progress',
        'date': '29 Jan, 2025',
        'week': 'Week 2',
        'image': "assets/icons/progresshistory.png",
      },
      {
        'title': 'Month 1 Milestone',
        'date': '15 Feb, 2025',
        'week': 'Week 4',
        'image': "assets/icons/progresshistory.png",
      },
    ];
  }
      void loadGraphData() {
     janData.value = [
       FlSpot(0, 3),
       FlSpot(1, 4),
       FlSpot(2, 2),
       FlSpot(3, 5),
       FlSpot(4, 3.5),
       FlSpot(5, 4.5),
       FlSpot(6, 3.8),
       FlSpot(7, 4.2),
       FlSpot(8, 3.9),
       FlSpot(9, 4.7),
       FlSpot(10, 3.6),
       FlSpot(11, 4.1),
     ];

     febData.value = [
       FlSpot(0, 2.5),
       FlSpot(1, 3.5),
       FlSpot(2, 4.5),
       FlSpot(3, 3),
       FlSpot(4, 4.8),
       FlSpot(5, 3.8),
       FlSpot(6, 4.3),
       FlSpot(7, 3.7),
       FlSpot(8, 4.6),
       FlSpot(9, 3.4),
       FlSpot(10, 4.9),
       FlSpot(11, 3.2),
     ];

     marData.value = [
       FlSpot(0, 3.2),
       FlSpot(1, 4.1),
       FlSpot(2, 3.8),
       FlSpot(3, 4.5),
       FlSpot(4, 3.3),
       FlSpot(5, 4.2),
       FlSpot(6, 3.9),
       FlSpot(7, 4.6),
       FlSpot(8, 3.7),
       FlSpot(9, 4.3),
       FlSpot(10, 3.5),
       FlSpot(11, 4.0),
     ];

     aprData.value = [
       FlSpot(0, 4.0),
       FlSpot(1, 3.8),
       FlSpot(2, 4.2),
       FlSpot(3, 3.6),
       FlSpot(4, 4.4),
       FlSpot(5, 3.9),
       FlSpot(6, 4.1),
       FlSpot(7, 3.7),
       FlSpot(8, 4.5),
       FlSpot(9, 3.4),
       FlSpot(10, 4.3),
       FlSpot(11, 3.8),
     ];

     mayData.value = [
       FlSpot(0, 3.5),
       FlSpot(1, 4.2),
       FlSpot(2, 3.9),
       FlSpot(3, 4.6),
       FlSpot(4, 3.3),
       FlSpot(5, 4.0),
       FlSpot(6, 3.7),
       FlSpot(7, 4.4),
       FlSpot(8, 3.8),
       FlSpot(9, 4.1),
       FlSpot(10, 3.6),
       FlSpot(11, 4.3),
     ];

     junData.value = [
       FlSpot(0, 4.1),
       FlSpot(1, 3.7),
       FlSpot(2, 4.3),
       FlSpot(3, 3.9),
       FlSpot(4, 4.5),
       FlSpot(5, 3.6),
       FlSpot(6, 4.2),
       FlSpot(7, 3.8),
       FlSpot(8, 4.6),
       FlSpot(9, 3.4),
       FlSpot(10, 4.0),
       FlSpot(11, 3.7),
     ];

     julData.value = [
       FlSpot(0, 3.8),
       FlSpot(1, 4.4),
       FlSpot(2, 3.6),
       FlSpot(3, 4.1),
       FlSpot(4, 3.9),
       FlSpot(5, 4.3),
       FlSpot(6, 3.7),
       FlSpot(7, 4.5),
       FlSpot(8, 3.5),
       FlSpot(9, 4.2),
       FlSpot(10, 3.8),
       FlSpot(11, 4.0),
     ];

     augData.value = [
       FlSpot(0, 4.2),
       FlSpot(1, 3.9),
       FlSpot(2, 4.5),
       FlSpot(3, 3.7),
       FlSpot(4, 4.1),
       FlSpot(5, 3.8),
       FlSpot(6, 4.4),
       FlSpot(7, 3.6),
       FlSpot(8, 4.3),
       FlSpot(9, 3.9),
       FlSpot(10, 4.0),
       FlSpot(11, 3.5),
     ];

     sepData.value = [
       FlSpot(0, 3.6),
       FlSpot(1, 4.3),
       FlSpot(2, 3.9),
       FlSpot(3, 4.7),
       FlSpot(4, 3.4),
       FlSpot(5, 4.1),
       FlSpot(6, 3.8),
       FlSpot(7, 4.5),
       FlSpot(8, 3.7),
       FlSpot(9, 4.2),
       FlSpot(10, 3.5),
       FlSpot(11, 4.4),
     ];

     octData.value = [
       FlSpot(0, 4.0),
       FlSpot(1, 3.8),
       FlSpot(2, 4.4),
       FlSpot(3, 3.6),
       FlSpot(4, 4.2),
       FlSpot(5, 3.9),
       FlSpot(6, 4.6),
       FlSpot(7, 3.5),
       FlSpot(8, 4.1),
       FlSpot(9, 3.7),
       FlSpot(10, 4.3),
       FlSpot(11, 3.8),
     ];

     novData.value = [
       FlSpot(0, 3.7),
       FlSpot(1, 4.1),
       FlSpot(2, 3.8),
       FlSpot(3, 4.5),
       FlSpot(4, 3.3),
       FlSpot(5, 4.2),
       FlSpot(6, 3.9),
       FlSpot(7, 4.4),
       FlSpot(8, 3.6),
       FlSpot(9, 4.0),
       FlSpot(10, 3.7),
       FlSpot(11, 4.3),
     ];

     decData.value = [
       FlSpot(0, 4.3),
       FlSpot(1, 3.6),
       FlSpot(2, 4.1),
       FlSpot(3, 3.8),
       FlSpot(4, 4.5),
       FlSpot(5, 3.7),
       FlSpot(6, 4.2),
       FlSpot(7, 3.9),
       FlSpot(8, 4.4),
       FlSpot(9, 3.5),
       FlSpot(10, 4.0),
       FlSpot(11, 3.8),
     ];
   }

  // Get all month data as a list
  List<RxList<FlSpot>> getAllMonthsData() {
    return [janData, febData, marData, aprData, mayData, junData, 
           julData, augData, sepData, octData, novData, decData];
  }

  // Get month names
  List<String> getMonthNames() {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  }

  // Get current month index (0-based)
  int getCurrentMonthIndex() {
    return DateTime.now().month - 1; // Convert to 0-based index
  }

  // Get previous month index (0-based)
  int getPreviousMonthIndex() {
    int currentMonth = getCurrentMonthIndex();
    return currentMonth == 0 ? 11 : currentMonth - 1; // Handle January wraparound
  }

  // Get current month data
  List<FlSpot> getCurrentMonthData() {
    int currentIndex = getCurrentMonthIndex();
    switch (currentIndex) {
      case 0: return janData.toList();
      case 1: return febData.toList();
      case 2: return marData.toList();
      case 3: return aprData.toList();
      case 4: return mayData.toList();
      case 5: return junData.toList();
      case 6: return julData.toList();
      case 7: return augData.toList();
      case 8: return sepData.toList();
      case 9: return octData.toList();
      case 10: return novData.toList();
      case 11: return decData.toList();
      default: return janData.toList();
    }
  }

  // Get previous month data
  List<FlSpot> getPreviousMonthData() {
    int previousIndex = getPreviousMonthIndex();
    switch (previousIndex) {
      case 0: return janData.toList();
      case 1: return febData.toList();
      case 2: return marData.toList();
      case 3: return aprData.toList();
      case 4: return mayData.toList();
      case 5: return junData.toList();
      case 6: return julData.toList();
      case 7: return augData.toList();
      case 8: return sepData.toList();
      case 9: return octData.toList();
      case 10: return novData.toList();
      case 11: return decData.toList();
      default: return febData.toList();
    }
  }

  // Get current month name
  String getCurrentMonthName() {
    return getMonthNames()[getCurrentMonthIndex()];
  }

  // Get previous month name
  String getPreviousMonthName() {
    return getMonthNames()[getPreviousMonthIndex()];
  }



  // Get visible months for the chart (current + 3 previous months)
  List<int> getVisibleMonthIndices() {
    int currentIndex = getCurrentMonthIndex();
    List<int> visibleIndices = [];
    
    // Add current month and 3 previous months
    for (int i = 0; i < 4; i++) {
      int monthIndex = (currentIndex - i + 12) % 12;
      visibleIndices.insert(0, monthIndex); // Insert at beginning to maintain order
    }
    
    return visibleIndices;
  }

  // Get data for visible months
  List<RxList<FlSpot>> getVisibleMonthsData() {
    List<int> visibleIndices = getVisibleMonthIndices();
    List<RxList<FlSpot>> allData = getAllMonthsData();
    return visibleIndices.map((index) => allData[index]).toList();
  }

  // Get names for visible months
  List<String> getVisibleMonthNames() {
    List<int> visibleIndices = getVisibleMonthIndices();
    List<String> allNames = getMonthNames();
    return visibleIndices.map((index) => allNames[index]).toList();
  }

  void toggleShowAll(){
    showAll.value = !showAll.value;
  }
  
  void toggleTimelineShowAll(){
    showTimelineAll.value = !showTimelineAll.value;
  }
  
  // Helper method to get access token
  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      debugPrint('=== Photo Progress Authentication Check ===');
      debugPrint('Access Token exists: ${token != null}');
      debugPrint('Token preview: ${token != null ? '${token.substring(0, token.length > 20 ? 20 : token.length)}...' : 'null'}');
      return token;
    } catch (e) {
      debugPrint('Error getting access token: $e');
      return null;
    }
  }

  // Upload single photo progress to API
  Future<bool> uploadSinglePhotoProgress(String imagePath, String type) async {
    try {
      EasyLoading.show(status: 'Uploading $type photo...');
      debugPrint('=== Uploading Single Photo Progress ===');
      debugPrint('Image Path: $imagePath');
      debugPrint('Type: $type');
      
      final accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token found for photo upload');
        EasyLoading.dismiss();
        return false;
      }
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.photoProgressCreate),
      );
      
      // Add headers with Bearer token
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
      });
      
      // Check if file exists
      final file = File(imagePath);
      if (!await file.exists()) {
        debugPrint('Image file does not exist: $imagePath');
        EasyLoading.dismiss();
        return false;
      }
      
      // Get file extension and determine content type
      String fileName = imagePath.split('/').last;
      String fileExtension = fileName.toLowerCase().split('.').last;
      
      debugPrint('=== File Details ===');
      debugPrint('Original fileName: $fileName');
      debugPrint('File extension: $fileExtension');
      
      // Ensure proper content type
      String contentType;
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        case 'webp':
          contentType = 'image/webp';
          break;
        case 'heif':
          contentType = 'image/heif';
          break;
        case 'heic':
          contentType = 'image/heic';
          break;
        case 'tiff':
          contentType = 'image/tiff';
          break;
        case 'avif':
          contentType = 'image/avif';
          break;
        default:
          contentType = 'image/jpeg';
          break;
      }
      
      debugPrint('Content-Type: $contentType');
      
      // Add image file to form data
      request.files.add(await http.MultipartFile.fromPath(
        'image', 
        imagePath,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ));
      
      // Add type field to form data
      request.fields['type'] = type;
      
      debugPrint('=== API Request Details ===');
      debugPrint('URL: ${Urls.photoProgressCreate}');
      debugPrint('Headers: ${request.headers}');
      debugPrint('Fields: ${request.fields}');
      debugPrint('Files: ${request.files.map((f) => '${f.field}: ${f.filename}').toList()}');
      
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      
      debugPrint('=== API Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: $responseString');
      
      EasyLoading.dismiss();
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseString);
        debugPrint('=== Upload Success ===');
        debugPrint('Response Data: $data');
        return true;
      } else {
        debugPrint('=== Upload Error ===');
        debugPrint('Error response: $responseString');
        
        // Log error response for debugging
        
        return false;
      }
    } catch (e) {
      debugPrint('Exception during photo upload: $e');
      EasyLoading.dismiss();
      return false;
    }
  }

  // Upload all 3 photos (left, right, front) individually
  Future<void> uploadAllPhotos(List<String> imagePaths) async {
    if (imagePaths.length != 3) {
      debugPrint('Invalid number of images. Expected 3, got ${imagePaths.length}');
      return;
    }
    
    debugPrint('=== Uploading All 3 Photos ===');
    final types = ['left', 'right', 'front'];
    int successCount = 0;
    
    // Upload each photo individually
    for (int i = 0; i < imagePaths.length; i++) {
      debugPrint('Uploading photo ${i + 1}/3: ${types[i]}');
      final success = await uploadSinglePhotoProgress(imagePaths[i], types[i]);
      if (success) {
        successCount++;
        debugPrint('Successfully uploaded ${types[i]} photo');
        
        // Immediately refresh this specific type after successful upload
        await getPhotoProgressByType(types[i]);
      } else {
        debugPrint('Failed to upload ${types[i]} photo');
      }
      
      // Small delay between uploads to prevent server overload
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    debugPrint('=== Upload Summary ===');
    debugPrint('Successfully uploaded: $successCount/3 photos');
    
    if (successCount == 3) {
      // Show success message briefly
      EasyLoading.showSuccess('All photos uploaded successfully!', duration: Duration(microseconds: 2));
      debugPrint('=== All Photos Uploaded Successfully ===');
      
      // Wait for success message to show, then refresh data and auto-navigate back
      Future.delayed(Duration(microseconds: 2), () async {
        debugPrint('=== Starting Auto Refresh and Navigation ===');
        
        // Refresh all photo progress silently
        await getAllPhotoProgress(showLoading: false);
        
        // Wait a bit more for data to sync properly
        await Future.delayed(Duration(seconds: 1));
        
        // Auto-navigate back to progress screen
        debugPrint('=== Auto Navigation Back ===');
        Get.back(); // Go back from TextPage
        Get.back(); // Go back from GoPicture to Progress screen
      });
    } else if (successCount > 0) {
      EasyLoading.showError('$successCount out of 3 photos uploaded', duration: Duration(microseconds: 2));
    } else {
      EasyLoading.showError('Failed to upload photos', duration: Duration(seconds: 2));
    }
  }

  // Get photo progress by specific type
  Future<void> getPhotoProgressByType(String type, {int page = 1, int limit = 20, bool showLoading = true}) async {
    try {
      if (showLoading) {
        EasyLoading.show(status: 'Loading $type photos...');
      }
      debugPrint('=== Getting Photo Progress by Type ===');
      debugPrint('Type: $type, Page: $page, Limit: $limit');
      
      final accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token found for getting photo progress');
        EasyLoading.dismiss();
        return;
      }
      
      final url = '${Urls.photoProgressGetAll}?type=$type&page=$page&limit=$limit';
      debugPrint('=== API Request Details ===');
      debugPrint('URL: $url');
      debugPrint('Headers: {Authorization: Bearer [TOKEN]}');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      
      debugPrint('=== API Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      
      if (showLoading) {
        EasyLoading.dismiss();
      }
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('=== Get Success ===');
        debugPrint('Response Data: $data');
        
        if (data['success'] == true && data['data'] != null) {
          final result = data['data']['result'] as List;
          final meta = data['data']['meta'];
          
          debugPrint('=== Processing $type Results ===');
          debugPrint('Total $type photos: ${result.length}');
          debugPrint('Meta data: $meta');
          
          // Clear existing images for this type only
          switch (type) {
            case 'left':
              leftProgressImages.clear();
              break;
            case 'right':
              rightProgressImages.clear();
              break;
            case 'front':
              frontProgressImages.clear();
              break;
          }
          
          // Process and add images to respective list
          for (var item in result) {
            final imageUrl = '${Urls.imageurl}${item['image']}';
            final itemType = item['type'];
            final date = item['date'];
            final createdAt = item['createdAt'];
            
            debugPrint('Processing: Type=$itemType, Date=$date, Created=$createdAt, Image=$imageUrl');

            // Try to parse createdAt into DateTime; fall back to parsing 'date' or null
            DateTime? parsed;
            try {
              if (createdAt != null) {
                parsed = DateTime.tryParse(createdAt.toString());
              }
              if (parsed == null && date != null) {
                // API sometimes returns a human-readable date like 'Sat Oct 18 2025'
                try {
                  parsed = DateTime.parse(date.toString());
                } catch (_) {
                  // Try parsing common human format
                  try {
                    parsed = DateTime.parse(DateTime.tryParse(date.toString())?.toIso8601String() ?? '');
                  } catch (_) {
                    parsed = null;
                  }
                }
              }
            } catch (e) {
              parsed = null;
            }

            if (itemType == type) {
              switch (type) {
                case 'left':
                  leftProgressImages.add(imageUrl);
                  leftProgressDates.add(parsed);
                  break;
                case 'right':
                  rightProgressImages.add(imageUrl);
                  rightProgressDates.add(parsed);
                  break;
                case 'front':
                  frontProgressImages.add(imageUrl);
                  frontProgressDates.add(parsed);
                  break;
              }
            }
          }
          
          debugPrint('=== $type Images Updated ===');
          debugPrint('$type images count: ${type == 'left' ? leftProgressImages.length : type == 'right' ? rightProgressImages.length : frontProgressImages.length}');
        } else {
          debugPrint('=== API Response Error ===');
          debugPrint('Success: ${data['success']}');
          debugPrint('Message: ${data['message']}');
        }
      } else {
        debugPrint('=== HTTP Error ===');
        debugPrint('Error response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception during getting $type photo progress: $e');
      if (showLoading) {
        EasyLoading.dismiss();
      }
    }
  }

  // Get all photo progress from API (loads all types)
  Future<void> getAllPhotoProgress({int page = 1, int limit = 20, bool showLoading = false}) async {
    try {
      if (showLoading) {
        EasyLoading.show(status: 'Loading photos...');
      }
      debugPrint('=== Getting All Photo Progress ===');
      
      // Load each type separately for better organization
      await getPhotoProgressByType('left', page: page, limit: limit, showLoading: false);
      await Future.delayed(Duration(milliseconds: 200)); // Small delay between requests
      
      await getPhotoProgressByType('right', page: page, limit: limit, showLoading: false);
      await Future.delayed(Duration(milliseconds: 200)); // Small delay between requests
      
      await getPhotoProgressByType('front', page: page, limit: limit, showLoading: false);
      
      if (showLoading) {
        EasyLoading.dismiss();
      }
      debugPrint('=== All Photo Types Loaded ===');
      debugPrint('Left images: ${leftProgressImages.length}');
      debugPrint('Right images: ${rightProgressImages.length}');
      debugPrint('Front images: ${frontProgressImages.length}');
      
    } catch (e) {
      debugPrint('Exception during getting all photo progress: $e');
      if (showLoading) {
        EasyLoading.dismiss();
      }
    }
  }

  // Method to save captured progress images from GoPicture
  void saveCapturedImages(List<String> imagePaths) {
    if (imagePaths.length >= 3) {
      debugPrint('=== Saving Captured Images ===');
      debugPrint('Left: ${imagePaths[0]}');
      debugPrint('Right: ${imagePaths[1]}');
      debugPrint('Front: ${imagePaths[2]}');
      
      // Upload all 3 photos to API first, then refresh from server
      uploadAllPhotos(imagePaths);
    }
  }
  
  // Method to get the first (latest) image for each angle
  String? getLatestLeftImage() => leftProgressImages.isEmpty ? null : leftProgressImages.first;
  String? getLatestRightImage() => rightProgressImages.isEmpty ? null : rightProgressImages.first;
  String? getLatestFrontImage() => frontProgressImages.isEmpty ? null : frontProgressImages.first;
  
  // Methods to get images by index for displaying in different positions
  String? getLeftImageAtIndex(int index) {
    return index < leftProgressImages.length ? leftProgressImages[index] : null;
  }
  
  String? getRightImageAtIndex(int index) {
    return index < rightProgressImages.length ? rightProgressImages[index] : null;
  }
  
  String? getFrontImageAtIndex(int index) {
    return index < frontProgressImages.length ? frontProgressImages[index] : null;
  }
  
  // Get total count of captured images for each angle
  int get leftImagesCount => leftProgressImages.length;
  int get rightImagesCount => rightProgressImages.length;
  int get frontImagesCount => frontProgressImages.length;

  // Helper to get earliest and latest dates for a given list of DateTime? entries
  DateTime? _earliestFromList(List<DateTime?> list) {
    final nonNull = list.where((e) => e != null).map((e) => e!).toList();
    if (nonNull.isEmpty) return null;
    nonNull.sort();
    return nonNull.first;
  }

  DateTime? _latestFromList(List<DateTime?> list) {
    final nonNull = list.where((e) => e != null).map((e) => e!).toList();
    if (nonNull.isEmpty) return null;
    nonNull.sort();
    return nonNull.last;
  }

  // Public getters for front image date range (null if unavailable)
  DateTime? get frontEarliestDate => _earliestFromList(frontProgressDates);
  DateTime? get frontLatestDate => _latestFromList(frontProgressDates);

  // Similarly for left/right if needed
  DateTime? get leftEarliestDate => _earliestFromList(leftProgressDates);
  DateTime? get leftLatestDate => _latestFromList(leftProgressDates);
  DateTime? get rightEarliestDate => _earliestFromList(rightProgressDates);
  DateTime? get rightLatestDate => _latestFromList(rightProgressDates);
  
  // Method to refresh photo progress data
  Future<void> refreshPhotoProgress() async {
    debugPrint('=== Refreshing Photo Progress ===');
    await getAllPhotoProgress();
  }
  
  // Method to refresh specific type photo progress
  Future<void> refreshPhotoProgressByType(String type) async {
    debugPrint('=== Refreshing $type Photo Progress ===');
    await getPhotoProgressByType(type);
  }
  
  // Method to upload photos via refresh button
  Future<void> uploadPhotosViaRefresh() async {
    // This would typically be called when user has captured new photos
    // For now, we'll just refresh the data from database
    debugPrint('=== Upload Photos Via Refresh Button ===');
    await getAllPhotoProgress();
  }
  
  // Method to refresh timeline data
  Future<void> refreshTimelineData() async {
    debugPrint('=== Refreshing Timeline Data ===');
    await loadData();
  }
}