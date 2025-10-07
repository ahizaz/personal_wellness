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
import 'package:shared_preferences/shared_preferences.dart';

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
    '2:00 am', '2:15 am', '2:30 am', '2:45 am',
    '3:00 am', '3:15 am', '3:30 am', '3:45 am',
    '4:00 am', '4:15 am', '4:30 am', '4:45 am',
    '5:00 am', '5:15 am', '5:30 am', '5:45 am',
    '6:00 am', '6:15 am', '6:30 am', '6:45 am',
    '7:00 am', '7:15 am', '7:30 am', '7:45 am',
    '8:00 am', '8:15 am', '8:30 am', '8:45 am',
    '9:00 am', '9:15 am', '9:30 am', '9:45 am',
    '10:00 am', '10:15 am', '10:30 am', '10:45 am',
    '11:00 am', '11:15 am', '11:30 am', '11:45 am',
  ];
  final List<String> availableeveningTimes = [
    '12:00 pm', '12:15 pm', '12:30 pm', '12:45 pm',
    '1:00 pm', '1:15 pm', '1:30 pm', '1:45 pm',
    '2:00 pm', '2:15 pm', '2:30 pm', '2:45 pm',
    '3:00 pm', '3:15 pm', '3:30 pm', '3:45 pm',
    '4:00 pm', '4:15 pm', '4:30 pm', '4:45 pm',
    '5:00 pm', '5:15 pm', '5:30 pm', '5:45 pm',
    '6:00 pm', '6:15 pm', '6:30 pm', '6:45 pm',
    '7:00 pm', '7:15 pm', '7:30 pm', '7:45 pm',
    '8:00 pm', '8:15 pm', '8:30 pm', '8:45 pm',
    '9:00 pm', '9:15 pm', '9:30 pm', '9:45 pm',
    '10:00 pm', '10:15 pm', '10:30 pm', '10:45 pm',
    '11:00 pm', '11:15 pm', '11:30 pm', '11:45 pm',
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
  final RxList<RoutineItem> allDayRoutines = <RoutineItem>[].obs;  // For All Day section
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
          final color = colors[convertedRoutines.length % colors.length];
          
          debugPrint('Processing Product: ${item.product.productName}');
          debugPrint('Morning times: ${item.morningTimeOfDay}');
          debugPrint('Evening times: ${item.eveningTimeOfDay}');
          
          // Create separate routine items for morning times
          if (item.morningTimeOfDay != null && item.morningTimeOfDay!.isNotEmpty) {
            for (var morningTime in item.morningTimeOfDay!) {
              convertedRoutines.add(RoutineItem(
                productName: '${item.product.productName} (Morning)',
                backgroundColor: color,
                time: morningTime,
                productId: item.product.id,
                startDate: DateTime.now(),
                endDate: DateTime.now().add(Duration(days: 30)),
              ));
              debugPrint('Added morning routine: ${item.product.productName} at $morningTime');
            }
          }
          
          // Create separate routine items for evening times
          if (item.eveningTimeOfDay != null && item.eveningTimeOfDay!.isNotEmpty) {
            for (var eveningTime in item.eveningTimeOfDay!) {
              convertedRoutines.add(RoutineItem(
                productName: '${item.product.productName} (Evening)',
                backgroundColor: color,
                time: eveningTime,
                productId: item.product.id,
                startDate: DateTime.now(),
                endDate: DateTime.now().add(Duration(days: 30)),
              ));
              debugPrint('Added evening routine: ${item.product.productName} at $eveningTime');
            }
          }
          
          // If no times are set, create one with default time
          if ((item.morningTimeOfDay == null || item.morningTimeOfDay!.isEmpty) && 
              (item.eveningTimeOfDay == null || item.eveningTimeOfDay!.isEmpty)) {
            convertedRoutines.add(RoutineItem(
              productName: item.product.productName,
              backgroundColor: color,
              time: _getTimeForCategory(item.category),
              productId: item.product.id,
              startDate: DateTime.now(),
              endDate: DateTime.now().add(Duration(days: 30)),
            ));
            debugPrint('Added default routine: ${item.product.productName}');
          }
        }
        
        // Debug: Print routines before sorting
        debugPrint('=== Routines Before Sorting ===');
        for (int i = 0; i < convertedRoutines.length; i++) {
          final routine = convertedRoutines[i];
          final timeDiff = _getTimeDifferenceInMinutes(now, routine.time);
          debugPrint('${i + 1}. ${routine.productName} - Time: ${routine.time} (${timeDiff} minutes from now)');
        }
        
        // Debug: Print unsorted routines with time differences
        debugPrint('=== Before Sorting ===');
        for (int i = 0; i < convertedRoutines.length; i++) {
          final routine = convertedRoutines[i];
          final timeDiff = _getTimeDifferenceInMinutes(now, routine.time);
          debugPrint('${i + 1}. ${routine.productName} - Time: ${routine.time} (${timeDiff} minutes from now)');
        }
        
        // Sort routines by upcoming time (closest to current time first)
        convertedRoutines.sort((a, b) {
          final timeDiffA = _getTimeDifferenceInMinutes(now, a.time);
          final timeDiffB = _getTimeDifferenceInMinutes(now, b.time);
          return timeDiffA.compareTo(timeDiffB); // Closest time first
        });
        
        // Debug: Print sorted routines
        debugPrint('=== After Sorting ===');
        for (int i = 0; i < convertedRoutines.length; i++) {
          final routine = convertedRoutines[i];
          final timeDiff = _getTimeDifferenceInMinutes(now, routine.time);
          debugPrint('${i + 1}. ${routine.productName} - Time: ${routine.time} (${timeDiff} minutes from now)');
        }
        
        // Create separate lists for time-based and all-day views
        allDayRoutines.assignAll(convertedRoutines);
        debugPrint('All Day Routines count: ${allDayRoutines.length}');
        
        // Filter out completed time slots for time-based view only
        await _filterCompletedTimeSlots(convertedRoutines);
        debugPrint('Time-based Routines count after filtering: ${convertedRoutines.length}');
        
        // Re-sort after filtering to ensure closest time is first
        final currentTime = DateTime.now();
        convertedRoutines.sort((a, b) {
          final timeDiffA = _getTimeDifferenceInMinutes(currentTime, a.time);
          final timeDiffB = _getTimeDifferenceInMinutes(currentTime, b.time);
          return timeDiffA.compareTo(timeDiffB); // Closest time first
        });
        
        // Debug: Print final sorted order after filtering
        debugPrint('=== Final Sorted Routines (After Filtering) ===');
        for (int i = 0; i < convertedRoutines.length; i++) {
          final routine = convertedRoutines[i];
          final timeDiff = _getTimeDifferenceInMinutes(currentTime, routine.time);
          debugPrint('${i + 1}. ${routine.productName} - Time: ${routine.time} (${timeDiff} minutes from now)');
        }
        
        routines.assignAll(convertedRoutines);
        debugPrint('Routine tab updated with ${routines.length} items, sorted by upcoming time');
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

  // Helper method to get time based on user selected times
  String _getTimeForCategory(String category) {
    // First check if user has selected any morning times
    if (selectedTimes.isNotEmpty) {
      return selectedTimes.first; // Return the first selected morning time
    }
    
    // If no morning times selected, check evening times
    if (selectedEveningTimes.isNotEmpty) {
      return selectedEveningTimes.first; // Return the first selected evening time
    }
    
    // If no times selected at all, return default based on category type
    switch (category.toLowerCase()) {
      case 'night cream':
      case 'night':
        return availableeveningTimes.first; // Default evening time
      default:
        return availableTimes.first; // Default morning time
    }
  }

  // Helper method to calculate time difference in minutes (prioritize upcoming times)
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
      var routineTime = DateTime(
        currentTime.year, 
        currentTime.month, 
        currentTime.day, 
        parsedTime.hour, 
        parsedTime.minute
      );
      
      // Calculate time difference in minutes
      int diffMinutes = routineTime.difference(currentTime).inMinutes;
      
      debugPrint('Time comparison: Current=${DateFormat('h:mm a').format(currentTime)}, Routine=$timeStr, Diff=$diffMinutes minutes');
      
      // If the routine time is in the past today (negative), consider it for tomorrow
      if (diffMinutes < 0) {
        // Add 24 hours (1440 minutes) to get tomorrow's time difference
        diffMinutes = diffMinutes + 1440;
        debugPrint('Past time adjusted for tomorrow: $diffMinutes minutes');
      }
      
      // Return the time difference (positive for upcoming times, including tomorrow's times)
      return diffMinutes;
    } catch (e) {
      debugPrint('Error parsing time for comparison: $timeStr, error: $e');
      return 999999; // Return large number for unparseable times
    }
  }

  // Method to mark the current time slot as completed (without removing routine)
  Future<void> markCurrentTimeSlotCompleted(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);
      
      // Find the closest upcoming routine for this product
      final productRoutines = routines.where((r) => r.productId == productId).toList();
      if (productRoutines.isEmpty) {
        debugPrint('No routines found for product: $productId');
        return;
      }
      
      // Find closest time
      RoutineItem? closestRoutine;
      int minTimeDiff = 999999;
      
      debugPrint('=== Finding Closest Time Slot to Complete ===');
      debugPrint('Current time: ${DateFormat('h:mm a').format(now)}');
      debugPrint('Available routines for product $productId:');
      
      for (var routine in productRoutines) {
        final timeDiff = _getTimeDifferenceInMinutes(now, routine.time);
        debugPrint('- ${routine.productName} at ${routine.time}: ${timeDiff} minutes from now');
        if (timeDiff < minTimeDiff) {
          minTimeDiff = timeDiff;
          closestRoutine = routine;
        }
      }
      
      debugPrint('Closest routine selected: ${closestRoutine?.productName} at ${closestRoutine?.time} (${minTimeDiff} minutes)');
      
      if (closestRoutine != null) {
        // Create a unique key for this time slot completion
        final completionKey = 'completed_${productId}_${closestRoutine.time}_$today';
        
        // Save completion status
        await prefs.setBool(completionKey, true);
        
        // Remove the completed time slot from current display
        routines.removeWhere((routine) => 
          routine.productId == productId && routine.time == closestRoutine!.time);
        
        // Re-sort remaining routines by closest time to show next upcoming routine
        final currentTime = DateTime.now();
        routines.sort((a, b) {
          final timeDiffA = _getTimeDifferenceInMinutes(currentTime, a.time);
          final timeDiffB = _getTimeDifferenceInMinutes(currentTime, b.time);
          return timeDiffA.compareTo(timeDiffB); // Closest time first
        });
        
        // Force refresh the reactive list to trigger UI update
        routines.refresh();
        
        debugPrint('Marked time slot as completed: ${closestRoutine.time} for product: $productId');
        debugPrint('Completion key: $completionKey');
        debugPrint('Remaining routines after completion: ${routines.length}');
        debugPrint('Next closest routine: ${routines.isNotEmpty ? '${routines.first.productName} at ${routines.first.time}' : 'None'}');
        debugPrint('UI refreshed to show next routine');
      }
    } catch (e) {
      debugPrint('Error marking time slot as completed: $e');
    }
  }

  // Method to mark the closest time slot as completed
  Future<void> removeRoutine(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);
      
      // Find the closest upcoming routine for this product
      final productRoutines = routines.where((r) => r.productId == productId).toList();
      if (productRoutines.isEmpty) {
        debugPrint('No routines found for product: $productId');
        return;
      }
      
      // Find closest time
      RoutineItem? closestRoutine;
      int minTimeDiff = 999999;
      
      for (var routine in productRoutines) {
        final timeDiff = _getTimeDifferenceInMinutes(now, routine.time);
        if (timeDiff < minTimeDiff) {
          minTimeDiff = timeDiff;
          closestRoutine = routine;
        }
      }
      
      if (closestRoutine != null) {
        // Create a unique key for this time slot completion
        final completionKey = 'completed_${productId}_${closestRoutine.time}_$today';
        
        // Save completion status
        await prefs.setBool(completionKey, true);
        
        // Remove from current display
        routines.removeWhere((routine) => 
          routine.productId == productId && routine.time == closestRoutine!.time);
        
        debugPrint('Marked time slot as completed: ${closestRoutine.time} for product: $productId');
        debugPrint('Completion key: $completionKey');
        debugPrint('Remaining routines: ${routines.length}');
      }
    } catch (e) {
      debugPrint('Error removing routine: $e');
    }
  }

  // Helper method to filter completed time slots
  Future<void> _filterCompletedTimeSlots(List<RoutineItem> routines) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      routines.removeWhere((routine) {
        final completionKey = 'completed_${routine.productId}_${routine.time}_$today';
        final isCompleted = prefs.getBool(completionKey) ?? false;
        if (isCompleted) {
          debugPrint('Filtering out completed time slot: ${routine.productName} at ${routine.time}');
        }
        return isCompleted;
      });
      
      debugPrint('After filtering completed time slots: ${routines.length} routines remaining');
    } catch (e) {
      debugPrint('Error filtering completed time slots: $e');
    }
  }

  // Refresh routines method
  Future<void> refreshRoutines() async {
    debugPrint('=== Refreshing Routines ===');
    await fetchRoutines();
    // Force update of reactive lists to trigger UI rebuild
    routines.refresh();
    allDayRoutines.refresh();
    debugPrint('Routines refreshed and UI updated');
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