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
  var totalCompletedToday = 0.obs; // Total completed routines today
  var totalRoutinesToday = 0.obs; // Total routines today (completed + pending)

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
    
    // Initialize progress counts
    updateTodayProgress();
  }

  void _listenToRoutineEvents() {
    try {
      final routineEvents = RoutineEvents.instance;
      // Listen to routine added events
      ever(routineEvents.routineAdded, (_) async {
        debugPrint('Routine event received in Today controller - refreshing data');
        await refreshRoutineData();
        await updateTodayProgress();
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
          if (timeStr.isEmpty) {
            return 1440; // Put empty times at the end
          }

          // Normalize time string format
          String normalizedTime = timeStr.replaceAll('.', ':').trim();
          
          // Check if it contains period indicators (morning/afternoon/night/evening)
          final lowerTime = normalizedTime.toLowerCase();
          if (lowerTime.contains('morning')) {
            // Morning routines: assign to early hours (6-11 AM)
            return 360; // 6:00 AM as default morning time
          } else if (lowerTime.contains('afternoon')) {
            // Afternoon routines: assign to afternoon hours (12-5 PM)
            return 840; // 2:00 PM as default afternoon time
          } else if (lowerTime.contains('night') || lowerTime.contains('evening')) {
            // Night/Evening routines: assign to evening hours (6-11 PM)
            return 1200; // 8:00 PM as default evening time
          }

          // Ensure proper AM/PM formatting
          bool hasAm = lowerTime.contains('am');
          bool hasPm = lowerTime.contains('pm');
          
          if (!hasAm && !hasPm) {
            // If no AM/PM specified, try to infer from context or default to AM
            normalizedTime += ' am';
          }

          // Convert to uppercase for proper parsing
          String upperTime = normalizedTime.toUpperCase();

          // Try multiple date formats
          List<DateFormat> formats = [
            DateFormat('h:mm aa'),      // "6:30 AM" or "6:30 PM"
            DateFormat('h:mm a'),       // "6:30 A" or "6:30 P"
            DateFormat('h:m aa'),       // "6:3 AM" format
            DateFormat('h:m a'),        // "6:3 A" format
            DateFormat('hh:mm aa'),     // "06:30 AM"
            DateFormat('hh:mm a'),      // "06:30 A"
            DateFormat('h:mmaa'),       // "6:30AM" (no space)
            DateFormat('h:mma'),        // "6:30AM" (no space, short)
          ];

          for (DateFormat format in formats) {
            try {
              final parsedTime = format.parse(upperTime);
              int minutes = parsedTime.hour * 60 + parsedTime.minute;
              
              // Handle 12:00 AM (midnight) and 12:00 PM (noon) correctly
              if (parsedTime.hour == 12) {
                if (hasAm) {
                  minutes = parsedTime.minute; // 12:XX AM = 0:XX (midnight)
                } else if (hasPm) {
                  minutes = 720 + parsedTime.minute; // 12:XX PM = 12:XX (noon)
                }
              }
              
              return minutes;
            } catch (e) {
              // Try next format
              continue;
            }
          }

          // If all parsing fails, try manual parsing
          final regex = RegExp(r'(\d{1,2}):(\d{1,2})\s*(am|pm|AM|PM|a|p|A|P)');
          final match = regex.firstMatch(upperTime);
          if (match != null) {
            int hour = int.parse(match.group(1)!);
            int minute = int.parse(match.group(2)!);
            String period = match.group(3)!.toUpperCase();
            
            // Convert to 24-hour format
            if (period.contains('AM')) {
              if (hour == 12) {
                hour = 0; // 12:XX AM = 0:XX
              }
            } else if (period.contains('PM')) {
              if (hour != 12) {
                hour += 12; // 1-11 PM = 13-23
              }
            }
            
            return hour * 60 + minute;
          }

          debugPrint('Failed to parse time for sorting: $timeStr');
          return 1440; // Put unparseable times at the end
        } catch (e) {
          debugPrint('Error parsing time for sorting: $timeStr, error: $e');
          return 1440; // Put errors at the end
        }
      }

      // Helper function to get period priority (morning=1, afternoon=2, night/evening=3)
      int _getPeriodPriority(Map<String, dynamic> routine) {
        final productName = (routine['productName'] ?? '').toString().toLowerCase();
        final id = (routine['id'] ?? '').toString().toLowerCase();
        final time = (routine['time'] ?? '').toString().toLowerCase();
        
        // Check product name first
        if (productName.contains('morning')) return 1;
        if (productName.contains('afternoon')) return 2;
        if (productName.contains('night') || productName.contains('evening')) return 3;
        
        // Check ID
        if (id.contains('morning')) return 1;
        if (id.contains('afternoon')) return 2;
        if (id.contains('night') || id.contains('evening')) return 3;
        
        // Check time string
        if (time.contains('morning')) return 1;
        if (time.contains('afternoon')) return 2;
        if (time.contains('night') || time.contains('evening')) return 3;
        
        // Infer from time value (AM = morning, PM = afternoon/evening)
        if (time.contains('am')) {
          // Parse hour to determine if it's morning (before 12 PM)
          try {
            final regex = RegExp(r'(\d{1,2})');
            final match = regex.firstMatch(time);
            if (match != null) {
              final hour = int.parse(match.group(1)!);
              if (hour >= 6 && hour < 12) return 1; // Morning
            }
          } catch (e) {
            // Ignore parsing errors
          }
          return 1; // Default AM to morning
        } else if (time.contains('pm')) {
          // Parse hour to determine if it's afternoon or evening
          try {
            final regex = RegExp(r'(\d{1,2})');
            final match = regex.firstMatch(time);
            if (match != null) {
              final hour = int.parse(match.group(1)!);
              // For PM times: 12 PM and 1-5 PM = afternoon, 6-11 PM = evening
              if (hour == 12 || (hour >= 1 && hour < 6)) return 2; // Afternoon (12 PM - 5 PM)
              if (hour >= 6 && hour < 12) return 3; // Evening (6 PM - 11 PM)
            }
          } catch (e) {
            // Ignore parsing errors
          }
          return 2; // Default PM to afternoon
        }
        
        return 0; // Unknown period
      }

      final List<Map<String, dynamic>> sortedByLatest =
          List<Map<String, dynamic>>.from(notCompletedToday)
            ..sort((a, b) {
              // First, sort by period (morning -> afternoon -> night)
              final aPeriod = _getPeriodPriority(a);
              final bPeriod = _getPeriodPriority(b);
              if (aPeriod != bPeriod) {
                return aPeriod.compareTo(bPeriod);
              }
              
              // If same period, sort by time
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
      
      // Update progress counts
      await updateTodayProgress();
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

  void toggleCompletion(int index, bool value) async {
    if (index >= 0 && index < routineData.length) {
      routineData[index]['isCompleted'].value = value;
      // Update progress counts after toggling completion
      await updateTodayProgress();
    }
  }

  Future<void> refreshRoutineData() async {
    await fetchHomeRoutineData();
    await updateTodayProgress();
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

  // Calculate and update total completed and total routines for today
  Future<void> updateTodayProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final routinesJson = prefs.getString('saved_routines') ?? '[]';
      final List<dynamic> routinesList = jsonDecode(routinesJson);
      
      // Update total routines count
      totalRoutinesToday.value = routinesList.length;
      
      // Count completed routines
      int completedCount = 0;
      for (final routineJson in routinesList) {
        final String id = (routineJson['id'] ?? '').toString();
        if (id.isEmpty) continue;
        final completionKey = 'completed_${id}_$todayStr';
        final isCompleted = prefs.getBool(completionKey) ?? false;
        if (isCompleted) {
          completedCount++;
        }
      }
      totalCompletedToday.value = completedCount;
    } catch (e) {
      debugPrint('Error updating today progress: $e');
      totalCompletedToday.value = 0;
      totalRoutinesToday.value = 0;
    }
  }
}