import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:personal_wellness/core/events/routine_events.dart';
import 'package:intl/intl.dart';

class RoutineItem {
  final String productName;
  final Color backgroundColor;
  final String time; // ✅ Field to store the time
  final String productId; // ✅ Field to store the product ID
  final DateTime startDate; // ✅ Field to store start date
  final DateTime endDate; // ✅ Field to store end date

  RoutineItem({
    required this.productName,
    required this.backgroundColor,
    required this.time, // ✅ Updated constructor
    required this.productId, // ✅ Added product ID
    required this.startDate, // ✅ Added start date
    required this.endDate, // ✅ Added end date
  });
}

class RoutineController extends GetxController {
  var selectedCategory = ''.obs;
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  var startFocused = false.obs;
  var endFocused = false.obs;
  var selectedMinute = 0.obs;
  var selectedSecond = 0.obs;
  var selectedAmPm = "AM".obs;
  var selectedHour = 1.obs;
  var selectedTimes = <String>[].obs;
  final TextEditingController instructionController = TextEditingController();
  final RxString productName = ''.obs;
  final RxString productId = ''.obs;

  var selectedOrder = 0.obs;
  var selectedEveningOrder = 0.obs;
  final List<String> availableTimes = [
    '12:00 am', '12:15 am', '12:30 am', '12:45 am',
      '1:00 am', '1:15 am', '1:30 am', '1:45 am',
    
    
  ];
   final List<String> availableeveningTimes = [
    '12:00 pm', '12:15 pm', '12:30 pm', '12:45 pm',
      '1:00 pm', '1:15 pm', '1:30 pm', '1:45 pm',

  ];

  var selectedEveningTimes = <String>[].obs;

  var visibleOrders = 3.obs;
  var visibleEvening = 3.obs;

  void toggleTimeSelection(String time) {
    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
    } else {
      selectedTimes.add(time);
    }
  }

  void toggleEveningTimeSelection(String time) {
    if (selectedEveningTimes.contains(time)) {
      selectedEveningTimes.remove(time);
    } else {
      selectedEveningTimes.add(time);
    }
  }

  final RxString instructionText = ''.obs;

  bool get hasMorningRoutine => selectedOrder.value != 0 && selectedTimes.isNotEmpty;
  
  bool get hasEveningRoutine => selectedEveningOrder.value != 0 && selectedEveningTimes.isNotEmpty;

  bool get isFormValid {
    // Check if at least one routine is selected (morning OR evening)
    return startDate.value != null &&
        endDate.value != null &&
        (hasMorningRoutine || hasEveningRoutine) &&
        instructionText.value.trim().isNotEmpty;
  }

  void setProductName(String name) {
    productName.value = name;
  }

  void setProductId(String id) {
    productId.value = id;
  }

  void setProductData(String name, String id) {
    productName.value = name;
    productId.value = id;
  }

  var progress = 0.obs;
  var progressMessage = 'Setting up your routine...'.obs;

  final RxList<RoutineItem> routines = <RoutineItem>[].obs;
  var isLoadingRoutines = false.obs;

void submitRoutine() async {
  try {
    progress.value = 0;
    progressMessage.value = 'Setting up your routine';

    // Debug print all the data being sent
    debugPrint('=== Submitting Routine ===');
    debugPrint('Product ID: ${productId.value}');
    debugPrint('Product Name: ${productName.value}');
    debugPrint('Category: ${selectedCategory.value}');
    debugPrint('Start Date: ${startDate.value}');
    debugPrint('End Date: ${endDate.value}');
    debugPrint('Morning Order: ${selectedOrder.value}');
    debugPrint('Morning Times: ${selectedTimes.toList()}');
    debugPrint('Evening Order: ${selectedEveningOrder.value}');
    debugPrint('Evening Times: ${selectedEveningTimes.toList()}');
    debugPrint('Instructions: ${instructionText.value}');

    await Future.delayed(const Duration(seconds: 1));
    progress.value = 50;
    progressMessage.value = 'Submitting';

    // Make API call
    final success = await ApiService.addProductToRoutine(
      productId: productId.value,
      category: selectedCategory.value.isNotEmpty ? selectedCategory.value : "Skincare",
      startDate: startDate.value!,
      endDate: endDate.value!,
      morningOrder: selectedOrder.value != 0 ? selectedOrder.value : null,
      morningTimeOfDay: selectedTimes.isNotEmpty ? selectedTimes.toList() : null,
      eveningOrder: selectedEveningOrder.value != 0 ? selectedEveningOrder.value : null,
      eveningTimeOfDay: selectedEveningTimes.isNotEmpty ? selectedEveningTimes.toList() : null,
      additionalIntroduction: instructionText.value,
    );

    await Future.delayed(const Duration(seconds: 1));
    progress.value = 75;
    progressMessage.value = 'Almost done';

    if (success) {
      await Future.delayed(const Duration(seconds: 1));
      progress.value = 100;
      progressMessage.value = 'Routine added successfully!';
      
      // Refresh routines from API to get the latest data
      await fetchRoutines();
      
      // Trigger global event to notify all listeners
      RoutineEvents.instance.notifyRoutineAdded();
      
      // Refresh Today controller to show new routine immediately
      try {
        final todayController = Get.find<TodayController>();
        debugPrint('Refreshing Today controller after routine added');
        await todayController.refreshRoutineData();
      } catch (e) {
        debugPrint('Today controller not found or error refreshing: $e');
        // This is normal if Today tab hasn't been visited yet
      }
    } else {
      progress.value = 100;
      progressMessage.value = 'Failed to add routine';
    }

    await Future.delayed(const Duration(seconds: 1));

    // Reset form
    selectedCategory.value = '';
    startDate.value = null;
    endDate.value = null;
    selectedOrder.value = 0;
    selectedEveningOrder.value = 0;
    selectedTimes.clear();
    selectedEveningTimes.clear();
    instructionText.value = '';
    productName.value = '';
    productId.value = '';
    instructionController.clear();

    Get.back();
    final BottomNavcontroller navController = Get.find();
    Get.off(() => BottomNavbar());
    navController.changeIndex(2);
  } catch (e) {
    debugPrint('Error in submitRoutine: $e');
    progress.value = 100;
    progressMessage.value = 'Error occurred';
  }
}
  // Fetch routines from API
  Future<void> fetchRoutines() async {
    try {
      isLoadingRoutines.value = true;
      debugPrint('=== Fetching Routines for Routine Tab ===');
      
      final response = await ApiService.getHomeRoutineData();
      
      if (response != null && response.success && response.data.result.isNotEmpty) {
        debugPrint('Found ${response.data.result.length} routines for routine tab');
        
        // Sort routines by creation date (most recent first)
        var sortedRoutines = response.data.result.toList();
        sortedRoutines.sort((a, b) {
          final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return dateB.compareTo(dateA); // Most recent first
        });
        
        // Convert API data to RoutineItem format
        final colors = [
          const Color(0xffFFF8E6),
          const Color(0xffE6F7F7),
          const Color(0xffF2E6FF),
          const Color(0xffE6FFE6),
        ];
        
        // Create routine items - find closest time to current time for each product
        List<RoutineItem> convertedRoutines = [];
        final now = DateTime.now();
        
        for (var item in sortedRoutines) {
          final color = colors[sortedRoutines.indexOf(item) % colors.length];
          
          // Collect all times for this routine
          List<String> allTimes = [];
          if (item.morningTimeOfDay != null && item.morningTimeOfDay!.isNotEmpty) {
            allTimes.addAll(item.morningTimeOfDay!);
          }
          if (item.eveningTimeOfDay != null && item.eveningTimeOfDay!.isNotEmpty) {
            allTimes.addAll(item.eveningTimeOfDay!);
          }
          
          if (allTimes.isNotEmpty) {
            // Find the time closest to current time
            String closestTime = allTimes.first;
            int smallestDifference = _getTimeDifferenceInMinutes(now, allTimes.first);
            
            for (var timeStr in allTimes) {
              int timeDiff = _getTimeDifferenceInMinutes(now, timeStr);
              if (timeDiff < smallestDifference) {
                smallestDifference = timeDiff;
                closestTime = timeStr;
              }
            }
            
            debugPrint('Product: ${item.product.productName}');
            debugPrint('All times: $allTimes');
            debugPrint('Current time: ${DateFormat('h:mm aa').format(now)}');
            debugPrint('Closest time: $closestTime (difference: $smallestDifference minutes)');
            
            convertedRoutines.add(RoutineItem(
              productName: item.product.productName,
              backgroundColor: color,
              time: closestTime,
              productId: item.product.id,
              startDate: DateTime.now(), // Default start date
              endDate: DateTime.now().add(Duration(days: 30)), // Default end date
            ));
          } else {
            // If no times are set, create one with default time
            convertedRoutines.add(RoutineItem(
              productName: item.product.productName,
              backgroundColor: color,
              time: _getTimeForCategory(item.category),
              productId: item.product.id,
              startDate: DateTime.now(), // Default start date
              endDate: DateTime.now().add(Duration(days: 30)), // Default end date
            ));
          }
        }
        
        routines.assignAll(convertedRoutines);
        debugPrint('Routine tab updated with ${routines.length} items');
      } else {
        debugPrint('No routines found for routine tab');
        routines.clear();
      }
    } catch (e) {
      debugPrint('Error fetching routines for routine tab: $e');
      routines.clear();
    } finally {
      isLoadingRoutines.value = false;
    }
  }

  // Helper method to get time based on category
  String _getTimeForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'skin':
      case 'skincare':
        return '8:00 am';
      case 'sun cream':
        return '9:00 am';
      case 'lotion':
        return '8:30 am';
      case 'serum':
        return '8:15 am';
      default:
        return '8:00 am';
    }
  }

  // Helper method to calculate time difference in minutes
  int _getTimeDifferenceInMinutes(DateTime currentTime, String timeStr) {
    try {
      // Normalize time string format
      String normalizedTime = timeStr.replaceAll('.', ':').trim();
      
      // Ensure proper AM/PM formatting
      if (!normalizedTime.toLowerCase().contains('am') && !normalizedTime.toLowerCase().contains('pm')) {
        normalizedTime += ' am'; // Default to AM if no period specified
      }
      
      // Convert to uppercase for proper parsing since DateFormat expects uppercase AM/PM
      String upperTime = normalizedTime.toUpperCase();
      
      // Use 'aa' for full form (AM/PM) or 'a' for single character (A/P)
      DateFormat format;
      if (upperTime.endsWith('AM') || upperTime.endsWith('PM')) {
        format = DateFormat('h:mm aa'); // For "6:30 AM" or "6:30 PM"
      } else {
        format = DateFormat('h:mm a'); // For "6:30 A" or "6:30 P"
      }
      final parsedTime = format.parse(upperTime);
      
      // Create DateTime object with today's date but the parsed time
      final routineTime = DateTime(
        currentTime.year, 
        currentTime.month, 
        currentTime.day, 
        parsedTime.hour, 
        parsedTime.minute
      );
      
      // Calculate absolute difference in minutes
      return routineTime.difference(currentTime).inMinutes.abs();
    } catch (e) {
      debugPrint('Error parsing time for comparison: $timeStr, error: $e');
      return 999999; // Return large number for unparseable times
    }
  }

  // Method to remove a specific routine by product ID
  void removeRoutine(String productId) {
    routines.removeWhere((routine) => routine.productId == productId);
    debugPrint('Routine removed for product ID: $productId');
    debugPrint('Remaining routines: ${routines.length}');
  }

  // Refresh routines method
  Future<void> refreshRoutines() async {
    await fetchRoutines();
  }

  @override
  void onInit() {
    super.onInit();
    // Don't use Get.arguments here as it can conflict with AddToRoutine's arguments handling
    // Product name will be set via setProductName() from AddToRoutine
    
    // Fetch routines when controller initializes
    fetchRoutines();
  }
}