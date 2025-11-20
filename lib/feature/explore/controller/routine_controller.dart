import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:personal_wellness/core/events/routine_events.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineItem {
  final String productName;
  final Color backgroundColor;
  final String time; // ✅ Field to store the time
  final String productId; // ✅ Field to store the product ID
  final DateTime startDate; // ✅ Field to store start date
  final DateTime endDate; // ✅ Field to store end date
  final String id; // ✅ Unique identifier for each routine item

  RoutineItem({
    required this.productName,
    required this.backgroundColor,
    required this.time, // ✅ Updated constructor
    required this.productId, // ✅ Added product ID
    required this.startDate, // ✅ Added start date
    required this.endDate, // ✅ Added end date
    required this.id, // ✅ Added unique ID
  });

  // Convert to JSON for SharedPreferences storage
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'backgroundColor': backgroundColor.value,
      'time': time,
      'productId': productId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'id': id,
    };
  }

  // Create from JSON for SharedPreferences loading
  static RoutineItem fromJson(Map<String, dynamic> json) {
    return RoutineItem(
      productName: json['productName'],
      backgroundColor: Color(json['backgroundColor']),
      time: json['time'],
      productId: json['productId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      id: json['id'],
    );
  }
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

  final RxList<RoutineItem> routines = <RoutineItem>[].obs;  // For time slots view (no completed)
  final RxList<RoutineItem> allDayRoutines = <RoutineItem>[].obs;  // For All Day section (no completed)
  final RxList<RoutineItem> timeSlotRoutines = <RoutineItem>[].obs;  // For timeline display (includes completed)
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
    progressMessage.value = 'Adding to routine';

    // Create routine items from selected times and save to SharedPreferences
    await _addRoutinesToSharedPreferences();

    await Future.delayed(const Duration(seconds: 1));
    progress.value = 75;
    progressMessage.value = 'Almost done';

    // Refresh routines from SharedPreferences
    await loadRoutinesFromSharedPreferences();
    
    progress.value = 100;
    progressMessage.value = 'Routine added successfully!';
    
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
  // Add routines to SharedPreferences when user submits a new routine
  Future<void> _addRoutinesToSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing routines from SharedPreferences
      final existingRoutinesJson = prefs.getString('saved_routines') ?? '[]';
      final List<dynamic> existingRoutinesList = jsonDecode(existingRoutinesJson);
      final List<RoutineItem> existingRoutines = existingRoutinesList
          .map((json) => RoutineItem.fromJson(json))
          .toList();

      // 1) Purge expired items (older than their endDate)
      final DateTime now = DateTime.now();
      existingRoutines.removeWhere((r) => r.endDate.isBefore(now));

      // Create color palette
      final colors = [
        const Color(0xffFFF8E6),
        const Color(0xffE6F7F7),
        const Color(0xffF2E6FF),
        const Color(0xffE6FFE6),
      ];

      // Generate new routines from selected times
      List<RoutineItem> newRoutines = [];
      
      // Add morning routines
        // Add morning routines (valid for only one day)
        for (String morningTime in selectedTimes) {
          // Remove older items for the same time slot so only the latest stays
          existingRoutines.removeWhere((r) => _isSameTimeSlot(r.time, morningTime));
          final start = startDate.value ?? DateTime.now();
          final end = start.add(Duration(days: 1));
          final newRoutine = RoutineItem(
            productName: '${productName.value} (Morning)',
            backgroundColor: colors[newRoutines.length % colors.length],
            time: morningTime,
            productId: productId.value,
            startDate: start,
            endDate: end,
            id: '${productId.value}_morning_${morningTime}_${DateTime.now().millisecondsSinceEpoch}_${newRoutines.length}',
          );
          newRoutines.add(newRoutine);
          debugPrint('Created morning routine: ${productName.value} at $morningTime');
        }

        // Add evening routines (valid for only one day)
        for (String eveningTime in selectedEveningTimes) {
          // Remove older items for the same time slot so only the latest stays
          existingRoutines.removeWhere((r) => _isSameTimeSlot(r.time, eveningTime));
          final start = startDate.value ?? DateTime.now();
          final end = start.add(Duration(days: 1));
          final newRoutine = RoutineItem(
            productName: '${productName.value} (Evening)',
            backgroundColor: colors[newRoutines.length % colors.length],
            time: eveningTime,
            productId: productId.value,
            startDate: start,
            endDate: end,
            id: '${productId.value}_evening_${eveningTime}_${DateTime.now().millisecondsSinceEpoch}_${newRoutines.length}',
          );
          newRoutines.add(newRoutine);
          debugPrint('Created evening routine: ${productName.value} at $eveningTime');
        }

      // Add new routines to existing ones (don't replace, add to the list)
      existingRoutines.addAll(newRoutines);
      
      // Convert back to JSON and save
      final allRoutinesJson = jsonEncode(existingRoutines.map((r) => r.toJson()).toList());
      await prefs.setString('saved_routines', allRoutinesJson);
      
      debugPrint('=== Saved ${newRoutines.length} new routines to SharedPreferences ===');
      debugPrint('New routines added:');
      for (var routine in newRoutines) {
        debugPrint('- ${routine.productName} at ${routine.time} (ID: ${routine.id})');
      }
      debugPrint('Total routines now: ${existingRoutines.length}');
    } catch (e) {
      debugPrint('Error saving routines to SharedPreferences: $e');
    }
  }

  // Load routines from SharedPreferences
  Future<void> loadRoutinesFromSharedPreferences() async {
    try {
      isLoadingRoutines.value = true;
      debugPrint('=== Loading Routines from SharedPreferences ===');
      
      final prefs = await SharedPreferences.getInstance();
      final routinesJson = prefs.getString('saved_routines') ?? '[]';
      final List<dynamic> routinesList = jsonDecode(routinesJson);
      
      if (routinesList.isEmpty) {
        debugPrint('No routines found in SharedPreferences');
        routines.clear();
        allDayRoutines.clear();
        timeSlotRoutines.clear();
        return;
      }

      // Convert JSON to RoutineItem objects
      final List<RoutineItem> loadedRoutines = routinesList
          .map((json) => RoutineItem.fromJson(json))
          .toList();

      debugPrint('Loaded ${loadedRoutines.length} routines from SharedPreferences');

      // Purge expired items and save back if any were removed
      final int beforePurge = loadedRoutines.length;
      loadedRoutines.removeWhere((r) => r.endDate.isBefore(DateTime.now()));
      // Extra cleanup: remove legacy items older than 24 hours based on timestamp in id
      final int beforeLegacyCleanup = loadedRoutines.length;
      final DateTime cutoff = DateTime.now().subtract(const Duration(hours: 24));
      loadedRoutines.removeWhere((r) {
        final ts = _extractTimestampFromId(r.id);
        // If timestamp is missing/unparsable (legacy), drop it; else keep only newer than cutoff
        return ts == null || ts.isBefore(cutoff);
      });
      if (loadedRoutines.length != beforePurge) {
        final purgedJson = jsonEncode(loadedRoutines.map((r) => r.toJson()).toList());
        await prefs.setString('saved_routines', purgedJson);
        debugPrint('Purged ${beforePurge - loadedRoutines.length} expired routines');
      }
      if (loadedRoutines.length != beforeLegacyCleanup) {
        final cleanedJson = jsonEncode(loadedRoutines.map((r) => r.toJson()).toList());
        await prefs.setString('saved_routines', cleanedJson);
        debugPrint('Removed ${beforeLegacyCleanup - loadedRoutines.length} legacy routines older than 24h');
      }

      // Sort routines by time (no more time-based filtering)
      loadedRoutines.sort((a, b) {
        try {
          // Parse times for proper sorting
          final timeA = _parseTimeForSorting(a.time);
          final timeB = _parseTimeForSorting(b.time);
          return timeA.compareTo(timeB);
        } catch (e) {
          // Fallback to string comparison if parsing fails
          return a.time.compareTo(b.time);
        }
      });

      // Time slot routines (for timeline display) - includes ALL routines (even completed)
      timeSlotRoutines.assignAll(loadedRoutines);
      
      // Filter out completed routines for "all day" and "today" views
      final filteredRoutines = await _getFilteredRoutinesForTimeSlots(loadedRoutines);
      
      // All day routines (for "All Day" section) - excludes completed
      allDayRoutines.assignAll(filteredRoutines);
      
      // Time slots view routines (for "Today" section) - excludes completed  
      routines.assignAll(filteredRoutines);

      debugPrint('Time Slot Routines (includes completed): ${timeSlotRoutines.length}');
      debugPrint('All Day Routines (excludes completed): ${allDayRoutines.length}');
      debugPrint('Today Routines (excludes completed): ${routines.length}');
      
      for (int i = 0; i < loadedRoutines.length; i++) {
        final routine = loadedRoutines[i];
        debugPrint('${i + 1}. ${routine.productName} at ${routine.time}');
      }
    } catch (e) {
      debugPrint('Error loading routines from SharedPreferences: $e');
      routines.clear();
      allDayRoutines.clear();
      timeSlotRoutines.clear();
    } finally {
      isLoadingRoutines.value = false;
    }
  }

  // Get filtered routines for time slots (remove completed ones)
  Future<List<RoutineItem>> _getFilteredRoutinesForTimeSlots(List<RoutineItem> allRoutines) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      return allRoutines.where((routine) {
        final completionKey = 'completed_${routine.id}_$today';
        final isCompleted = prefs.getBool(completionKey) ?? false;
        if (isCompleted) {
          debugPrint('Filtering out completed routine: ${routine.productName} at ${routine.time}');
        }
        return !isCompleted;
      }).toList();
    } catch (e) {
      debugPrint('Error filtering routines: $e');
      return allRoutines;
    }
  }

  // Helper method to parse time for sorting
  int _parseTimeForSorting(String timeStr) {
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
      
      // Return minutes from midnight for sorting
      return parsedTime.hour * 60 + parsedTime.minute;
    } catch (e) {
      debugPrint('Error parsing time for sorting: $timeStr, error: $e');
      // Fallback: return a high number for unparseable times so they appear at end
      return 9999;
    }
  }

  // Helper: check if two time strings point to the same slot (minute precision)
  bool _isSameTimeSlot(String a, String b) {
    try {
      return _parseTimeForSorting(a) == _parseTimeForSorting(b);
    } catch (_) {
      return a.trim().toLowerCase() == b.trim().toLowerCase();
    }
  }

  // Extract timestamp (as DateTime) from our id format `${productId}_<period>_<time>_<timestamp>_<index>`
  DateTime? _extractTimestampFromId(String id) {
    try {
      final parts = id.split('_');
      if (parts.length < 2) return null;
      final tsStr = parts[parts.length - 2];
      final ts = int.tryParse(tsStr);
      if (ts == null || ts <= 0) return null;
      return DateTime.fromMillisecondsSinceEpoch(ts);
    } catch (_) {
      return null;
    }
  }

  // Check if a routine is completed today
  Future<bool> isRoutineCompleted(String routineId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final completionKey = 'completed_${routineId}_$today';
      return prefs.getBool(completionKey) ?? false;
    } catch (e) {
      debugPrint('Error checking routine completion: $e');
      return false;
    }
  }

  // Updated fetchRoutines method to load from SharedPreferences
  Future<void> fetchRoutines() async {
    await loadRoutinesFromSharedPreferences();
  }



  // Method to mark a specific routine as completed
  Future<void> markRoutineCompleted(String routineId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Find the routine to mark as completed
      final routineToComplete = routines.firstWhere(
        (routine) => routine.id == routineId,
        orElse: () => allDayRoutines.firstWhere(
          (routine) => routine.id == routineId,
          orElse: () => throw Exception('Routine not found'),
        ),
      );
      
      debugPrint('=== Marking Routine as Completed ===');
      debugPrint('Routine: ${routineToComplete.productName} at ${routineToComplete.time}');
      debugPrint('Routine ID: $routineId');
      
      // Create completion key using routine ID
      final completionKey = 'completed_${routineId}_$today';
      
      // Save completion status
      await prefs.setBool(completionKey, true);
      
      // Remove from "All Day" section (allDayRoutines)
      allDayRoutines.removeWhere((routine) => routine.id == routineId);
      
      // Remove from "Today" section (routines) 
      routines.removeWhere((routine) => routine.id == routineId);
      
      // BUT keep in timeSlotRoutines for timeline display (stays in time slot)
      // timeSlotRoutines keeps all routines regardless of completion status
      
      // Force refresh the reactive lists
      routines.refresh();
      allDayRoutines.refresh();
      timeSlotRoutines.refresh();
      
      debugPrint('✅ Routine marked as completed');
      debugPrint('❌ Removed from All Day section');
      debugPrint('❌ Removed from Today section');
      debugPrint('🟢 BUT kept in Time Slot timeline with GREEN color');
      debugPrint('Completion key: $completionKey');
      debugPrint('Remaining All Day routines: ${allDayRoutines.length}');
      debugPrint('Remaining Today routines: ${routines.length}');
      debugPrint('Time Slot routines (all): ${timeSlotRoutines.length}');
      
      // Notify today controller to refresh
      try {
        final todayController = Get.find<TodayController>();
        await todayController.refreshRoutineData();
      } catch (e) {
        debugPrint('Today controller not found: $e');
      }
      
      // Refresh progress controller to update timeline and charts
      try {
        final progressController = Get.find<ProgressController>();
        await progressController.fetchRoutineChartData();
        await progressController.refreshTimelineData();
      } catch (e) {
        debugPrint('Progress controller not found: $e');
      }
      
    } catch (e) {
      debugPrint('Error marking routine as completed: $e');
    }
  }

  // Method for backward compatibility - marks routine by product ID
  Future<void> markCurrentTimeSlotCompleted(String productId) async {
    try {
      // Find first routine with this product ID
      final routine = routines.firstWhere(
        (r) => r.productId == productId,
        orElse: () => allDayRoutines.firstWhere(
          (r) => r.productId == productId,
          orElse: () => throw Exception('No routine found for product: $productId'),
        ),
      );
      
      await markRoutineCompleted(routine.id);
    } catch (e) {
      debugPrint('Error marking routine by product ID: $e');
    }
  }

  // Method for backward compatibility
  Future<void> removeRoutine(String productId) async {
    await markCurrentTimeSlotCompleted(productId);
  }

  // Refresh routines method
  Future<void> refreshRoutines() async {
    debugPrint('=== Refreshing Routines ===');
    await fetchRoutines();
    // Force update of reactive lists to trigger UI rebuild
    routines.refresh();
    allDayRoutines.refresh();
    timeSlotRoutines.refresh();
    debugPrint('Routines refreshed and UI updated');
  }

  // Constants for time slot calculations
  static const double routineSlotDuration = 15.0; // 15 minutes per slot

  // Helper method to calculate routine container height based on duration
  double calculateRoutineHeight() {
    return routineSlotDuration * 4.0.h; // 15 minutes = 60px height
  }

  @override
  void onInit() {
    super.onInit();
    // Don't use Get.arguments here as it can conflict with AddToRoutine's arguments handling
    // Product name will be set via setProductName() from AddToRoutine
    
    // Load routines from SharedPreferences when controller initializes
    _runOneTimeMigrationIfNeeded().then((_) => loadRoutinesFromSharedPreferences());
  }

  // Clear all routines from SharedPreferences
  Future<void> clearAllRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_routines', '[]');
    debugPrint('All routines cleared from SharedPreferences');
    // Optionally refresh controllers to update UI
    try {
      final todayController = Get.find<TodayController>();
      await todayController.refreshRoutineData();
    } catch (e) {
      debugPrint('Today controller not found or error refreshing: $e');
    }
    routines.clear();
    allDayRoutines.clear();
    timeSlotRoutines.clear();
  }

  // One-time migration: clear all old routines so app starts fresh
  Future<void> _runOneTimeMigrationIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const migrationFlag = 'migration_clear_routines_v1';
      final hasRun = prefs.getBool(migrationFlag) ?? false;
      if (!hasRun) {
        await prefs.setString('saved_routines', '[]');
        await prefs.setBool(migrationFlag, true);
        debugPrint('Migration v1 applied: cleared all saved routines');
      }
    } catch (e) {
      debugPrint('Migration v1 error: $e');
    }
  }
}