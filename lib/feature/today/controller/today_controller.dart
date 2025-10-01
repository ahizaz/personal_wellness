import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/events/routine_events.dart';
import 'package:personal_wellness/core/models/routine_home_model.dart';

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
    // Add a small delay to ensure SharedPreferences is ready
    Future.delayed(Duration(milliseconds: 500), () {
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

  Future<void> fetchHomeRoutineData() async {
    try {
      isLoading.value = true;
      debugPrint('=== Fetching Home Routine Data ===');
      
      // Check authentication first
      final isAuthenticated = await checkAuthentication();
      if (!isAuthenticated) {
        debugPrint('User not authenticated - clearing routine data');
        routineData.clear();
        return;
      }
      
      final response = await ApiService.getHomeRoutineData();
      
      debugPrint('API Response: $response');
      debugPrint('Response success: ${response?.success}');
      debugPrint('Response data result length: ${response?.data.result.length}');
      
      if (response == null) {
        debugPrint('API response is null - likely authentication issue');
        routineData.clear();
      } else if (response.success) {
        if (response.data.result.isEmpty) {
          debugPrint('No routines found in response - showing empty view');
          routineData.clear();
        } else {
          debugPrint('Found ${response.data.result.length} routines');
          
          // Sort routines by creation date (most recent first)
          var sortedRoutines = response.data.result.toList();
          sortedRoutines.sort((a, b) {
            final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA); // Most recent first
          });
          
          // Take only the most recent 3 items
          final routineItems = sortedRoutines.take(3).toList();
          debugPrint('Showing ${routineItems.length} most recent routines');
          
          // Convert API data to the format expected by the UI
          final formattedData = routineItems.map((item) {
            debugPrint('Adding routine: ${item.category} - ${item.product.productName}');
            return {
              'icon': _getCategoryIcon(item.category),
              'title': item.category,
              'description': item.product.productName,
              'time': _getActualSelectedTime(item),
              'isCompleted': RxBool(false),
              'productId': item.product.id, // Add product ID for navigation
            };
          }).toList();
          
          routineData.assignAll(formattedData);
          debugPrint('Routine data updated with ${routineData.length} items');
        }
      } else {
        debugPrint('API request failed - response success: ${response.success}');
        routineData.clear();
      }
    } catch (e) {
      debugPrint('Error fetching routine data: $e');
      // Clear routine data if API fails
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

  String _getActualSelectedTime(RoutineItem item) {
    debugPrint('Getting time for item: ${item.category}');
    debugPrint('Morning times: ${item.morningTimeOfDay}');
    debugPrint('Evening times: ${item.eveningTimeOfDay}');
    
    // Combine all available times (morning and evening)
    List<String> allTimes = [];
    
    if (item.morningTimeOfDay != null && item.morningTimeOfDay!.isNotEmpty) {
      allTimes.addAll(item.morningTimeOfDay!);
    }
    
    if (item.eveningTimeOfDay != null && item.eveningTimeOfDay!.isNotEmpty) {
      allTimes.addAll(item.eveningTimeOfDay!);
    }
    
    // If we have any selected times, show the first one
    if (allTimes.isNotEmpty) {
      debugPrint('Using selected time: ${allTimes.first}');
      return allTimes.first;
    }
    
    // If no times found, show current time as fallback
    debugPrint('No selected times found, using current time');
    return _getCurrentTime();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    
    // Convert to 12-hour format
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayMinute = minute.toString().padLeft(2, '0');
    
    return '$displayHour:$displayMinute $amPm';
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