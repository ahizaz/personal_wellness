import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/events/routine_events.dart';
import 'package:intl/intl.dart';

class TodayController extends GetxController {
  var userName = "".obs; // Username (empty by default)
  var profileImagePath = "".obs; // Default no image
  var routineData = <Map<String, dynamic>>[].obs; // Reactive list for routine data
  var isLoading = false.obs; // Loading state

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty data
    routineData.clear();
    // Load personalization data
    loadPersonalizationData();
    // Add a small delay to ensure SharedPreferences is ready
    Future.delayed(Duration(milliseconds: 500), () async {
      await _runOneTimeMigrationIfNeeded();
      fetchHomeRoutineData();
    });
  }

  @override
  void onReady() {
    super.onReady();
    // This is called after the widget is rendered
    // Refresh data to ensure we have the latest
    refreshRoutineData();
    
    // Listen to routine events
    _listenToRoutineEvents();
  }

  void _listenToRoutineEvents() {
    try {
      final routineEvents = RoutineEvents.instance;
      // Listen to routine added events
      ever(routineEvents.routineAdded, (_) {
        debugPrint('Routine event received in Today controller - refreshing data');
        refreshRoutineData();
      });
    } catch (e) {
      debugPrint('Error setting up routine event listener: $e');
    }
  }

  // Load personalization data from SharedPreferences
  Future<void> loadPersonalizationData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Priority:
      // 1) personalization_firstName (server-side saved)
      // 2) local cached 'user_name' (saved by Firebase or other flows)
      // 3) FirebaseAuth currentUser.displayName (if available)
      String? firstName = prefs.getString('personalization_firstName');
      final cachedName = prefs.getString('user_name');

      if (firstName != null && firstName.isNotEmpty) {
        userName.value = firstName;
        debugPrint('Loaded personalization_firstName: $firstName');
        return;
      }

      if (cachedName != null && cachedName.isNotEmpty) {
        userName.value = cachedName;
        debugPrint('Loaded cached user_name from prefs: $cachedName');
        return;
      }

      // If we don't have a cached name, try to fetch profile from backend
      try {
        final fetched = await ApiService.fetchAndCacheUserProfile();
        if (fetched) {
          final newFirstName = prefs.getString('personalization_firstName');
          if (newFirstName != null && newFirstName.isNotEmpty) {
            userName.value = newFirstName;
            debugPrint('Loaded personalization_firstName from backend: $newFirstName');
            // Also cache a quick fallback
            await prefs.setString('user_name', userName.value);
            return;
          }
        }
      } catch (e) {
        debugPrint('Error fetching profile from backend: $e');
      }

      try {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        final display = firebaseUser?.displayName;
        if (display != null && display.isNotEmpty) {
          userName.value = display.split(' ').first; // use first name
          debugPrint('Loaded displayName from FirebaseAuth: ${userName.value}');
          // Cache it locally for faster startup next time
          await prefs.setString('user_name', userName.value);
          return;
        }
      } catch (e) {
        debugPrint('Error checking FirebaseAuth in loadPersonalizationData: $e');
      }

      debugPrint('No personalization data found; userName remains empty');
    } catch (e) {
      debugPrint('Error loading personalization data: $e');
    }
  }

  // Public method to refresh personalization data
  Future<void> refreshPersonalizationData() async {
    await loadPersonalizationData();
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
        debugPrint('TodayController migration v1 applied: cleared all saved routines');
      }
    } catch (e) {
      debugPrint('TodayController migration v1 error: $e');
    }
  }

  Future<void> fetchHomeRoutineData() async {
    try {
      isLoading.value = true;
      debugPrint('=== Fetching Home Routine Data from SharedPreferences ===');
      
      final prefs = await SharedPreferences.getInstance();
      final routinesJson = prefs.getString('saved_routines') ?? '[]';
      final List<dynamic> routinesList = jsonDecode(routinesJson);
      
      if (routinesList.isEmpty) {
        debugPrint('No routines found in SharedPreferences');
        routineData.clear();
        return;
      }

      debugPrint('Found ${routinesList.length} routines in SharedPreferences');

      // Exclude routines already completed today so they don't reappear
      final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final List<Map<String, dynamic>> notCompletedToday =
          List<Map<String, dynamic>>.from(routinesList.cast<Map<String, dynamic>>())
              .where((routineJson) {
        final String id = (routineJson['id'] ?? '').toString();
        if (id.isEmpty) return true;
        final completionKey = 'completed_${id}_$todayStr';
        final bool isCompleted = prefs.getBool(completionKey) ?? false;
        return !isCompleted;
      }).toList();
      debugPrint('Filtered not completed today: ${notCompletedToday.length}');

      // Sort by time of day (chronological order: morning -> afternoon -> evening)
      int _parseTimeForSorting(String timeStr) {
        try {
          // Normalize time string format
          String normalizedTime = timeStr.replaceAll('.', ':').trim();

          // Ensure proper AM/PM formatting
          if (!normalizedTime.toLowerCase().contains('am') &&
              !normalizedTime.toLowerCase().contains('pm')) {
            normalizedTime += ' am'; // Default to AM if no period specified
          }

          // Convert to uppercase for proper parsing
          String upperTime = normalizedTime.toUpperCase();

          // Parse the time
          DateFormat format;
          if (upperTime.endsWith('AM') || upperTime.endsWith('PM')) {
            format = DateFormat('h:mm aa'); // For "6:30 AM" or "6:30 PM"
          } else {
            format = DateFormat('h:mm a'); // For "6:30 A" or "6:30 P"
          }

          try {
            final parsedTime = format.parse(upperTime);
            // Return minutes since midnight for sorting
            return parsedTime.hour * 60 + parsedTime.minute;
          } catch (e) {
            // Try alternative formats
            DateFormat alternativeFormat;
            if (upperTime.endsWith('AM') || upperTime.endsWith('PM')) {
              alternativeFormat = DateFormat('h:m aa'); // For "6:3 AM" format
            } else {
              alternativeFormat = DateFormat('h:m a'); // For "6:3 A" format
            }
            final parsedTime = alternativeFormat.parse(upperTime);
            return parsedTime.hour * 60 + parsedTime.minute;
          }
        } catch (e) {
          debugPrint('Failed to parse time for sorting: $timeStr, error: $e');
          return 0; // Default to start of day if parsing fails
        }
      }

      final List<Map<String, dynamic>> sortedByLatest =
          List<Map<String, dynamic>>.from(notCompletedToday)
            ..sort((a, b) {
              final aTime = _parseTimeForSorting(a['time'] ?? '');
              final bTime = _parseTimeForSorting(b['time'] ?? '');
              return aTime.compareTo(bTime); // Ascending order: earliest first
            });

      // Don't deduplicate - show all routines including same product at different times (morning/evening)
      // Each routine has a unique ID that includes productId, period (morning/evening), time, timestamp, and index
      final List<Map<String, dynamic>> uniqueLatestFirst = [];
      for (final routineJson in sortedByLatest) {
        final id = (routineJson['id'] ?? '').toString();
        if (id.isEmpty) continue;
        // Add all routines - they should all have unique IDs
        uniqueLatestFirst.add(routineJson);
      }

      // Take the most recent items for today view (up to all available)
      final recentRoutines = uniqueLatestFirst.toList();

      // Convert JSON data to the format expected by the UI
      final formattedData = recentRoutines.map((routineJson) {
        final productName = routineJson['productName'] ?? '';
        final time = routineJson['time'] ?? '';
        final productId = routineJson['productId'] ?? '';
        final id = routineJson['id'] ?? '';
        final startDateStr = routineJson['startDate'] ?? '';
        final endDateStr = routineJson['endDate'] ?? '';
        
        // Parse dates if available
        DateTime? startDate;
        DateTime? endDate;
        try {
          if (startDateStr.isNotEmpty) startDate = DateTime.parse(startDateStr);
          if (endDateStr.isNotEmpty) endDate = DateTime.parse(endDateStr);
        } catch (e) {
          debugPrint('Error parsing dates: $e');
        }

        debugPrint('Adding routine: $productName at $time');
        return {
          'icon': _getCategoryIcon('skincare'), // Default category
          'title': 'Skincare', // Default title
          'description': productName,
          'time': time,
          'isCompleted': RxBool(false),
          'productId': productId,
          'id': id,
          'startDate': startDate,
          'endDate': endDate,
        };
      }).toList();

      routineData.assignAll(formattedData);
      debugPrint('Today view updated with ${routineData.length} items');
    } catch (e) {
      debugPrint('Error fetching routine data from SharedPreferences: $e');
      routineData.clear();
    } finally {
      isLoading.value = false;
      debugPrint('Final routine data length: ${routineData.length}');
    }
  }



  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'skin':
      case 'skincare':
        return IconPath.cleanser;
      case 'sun cream':
        return IconPath.sun;
      case 'lotion':
        return IconPath.lotion;
      case 'serum':
        return IconPath.serum;
      default:
        return IconPath.cleanser;
    }
  }

  void setUserName(String name) {
    userName.value = name;
  }

  void setProfileImage(String path) {
    profileImagePath.value = path;
  }

  void toggleCompletion(int index, bool value) {
    if (index >= 0 && index < routineData.length) {
      routineData[index]['isCompleted'].value = value;
    }
  }

  Future<void> refreshRoutineData() async {
    await fetchHomeRoutineData();
  }

  // Method to be called when returning from Add Routine screen
  void onReturnFromAddRoutine() {
    refreshRoutineData();
  }

  // Method to clear all routine data
  void clearRoutineData() {
    routineData.clear();
    debugPrint('Routine data cleared');
  }

  // Method to check if user is authenticated
  Future<bool> checkAuthentication() async {
    final token = await ApiService.getAccessToken();
    final isAuthenticated = token != null && token.isNotEmpty;
    debugPrint('User authenticated: $isAuthenticated');
    return isAuthenticated;
  }

  // Debug method to check full authentication state
  Future<void> debugAuthenticationState() async {
    debugPrint('=== DEBUG: Full Authentication State ===');
    await checkAuthentication();
    debugPrint('Current routine data length: ${routineData.length}');
    debugPrint('Is loading: ${isLoading.value}');
    
    // Try to fetch data again
    debugPrint('Attempting to fetch routine data...');
    await fetchHomeRoutineData();
  }
}