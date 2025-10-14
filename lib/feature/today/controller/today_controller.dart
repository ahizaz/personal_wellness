import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/events/routine_events.dart';

class TodayController extends GetxController {
  var userName = "Liana".obs; // Default username
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
      final firstName = prefs.getString('personalization_firstName');
      
      if (firstName != null && firstName.isNotEmpty) {
        userName.value = firstName;
        debugPrint('=== LOADED PERSONALIZATION DATA ===');
        debugPrint('First Name: $firstName');
        debugPrint('Updated userName to: ${userName.value}');
        debugPrint('==================================');
      } else {
        debugPrint('=== NO PERSONALIZATION DATA FOUND ===');
        debugPrint('Using default userName: ${userName.value}');
        debugPrint('====================================');
      }
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

      // Sort by creation time descending using timestamp embedded in the id
      // id format: `${productId}_<period>_<time>_<timestamp>_<index>`
      int _extractTimestamp(Map<String, dynamic> json) {
        try {
          final String id = (json['id'] ?? '').toString();
          final parts = id.split('_');
          // timestamp is the second last segment
          if (parts.length >= 2) {
            final tsStr = parts[parts.length - 2];
            return int.tryParse(tsStr) ?? 0;
          }
          return 0;
        } catch (_) {
          return 0;
        }
      }

      final List<Map<String, dynamic>> sortedByLatest =
          List<Map<String, dynamic>>.from(routinesList.cast<Map<String, dynamic>>())
            ..sort((a, b) => _extractTimestamp(b).compareTo(_extractTimestamp(a)));

      // Deduplicate by productId preserving latest first
      final seenProductIds = <String>{};
      final List<Map<String, dynamic>> uniqueLatestFirst = [];
      for (final routineJson in sortedByLatest) {
        final productId = (routineJson['productId'] ?? '').toString();
        if (productId.isEmpty) continue;
        if (seenProductIds.add(productId)) {
          uniqueLatestFirst.add(routineJson);
        }
      }

      // Take only the most recent 3 unique items for today view
      final recentRoutines = uniqueLatestFirst.take(3).toList();

      // Convert JSON data to the format expected by the UI
      final formattedData = recentRoutines.map((routineJson) {
        final productName = routineJson['productName'] ?? '';
        final time = routineJson['time'] ?? '';
        final productId = routineJson['productId'] ?? '';

        debugPrint('Adding routine: $productName at $time');
        return {
          'icon': _getCategoryIcon('skincare'), // Default category
          'title': 'Skincare', // Default title
          'description': productName,
          'time': time,
          'isCompleted': RxBool(false),
          'productId': productId,
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