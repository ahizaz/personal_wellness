import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/models/routine_home_model.dart';
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
        print('Routine event received in Today controller - refreshing data');
        refreshRoutineData();
      });
    } catch (e) {
      print('Error setting up routine event listener: $e');
    }
  }

  Future<void> fetchHomeRoutineData() async {
    try {
      isLoading.value = true;
      print('=== Fetching Home Routine Data ===');
      
      // Check authentication first
      final isAuthenticated = await checkAuthentication();
      if (!isAuthenticated) {
        print('User not authenticated - clearing routine data');
        routineData.clear();
        return;
      }
      
      final response = await ApiService.getHomeRoutineData();
      
      print('API Response: $response');
      print('Response success: ${response?.success}');
      print('Response data result length: ${response?.data.result.length}');
      
      if (response == null) {
        print('API response is null - likely authentication issue');
        routineData.clear();
      } else if (response.success) {
        if (response.data.result.isEmpty) {
          print('No routines found in response - showing empty view');
          routineData.clear();
        } else {
          print('Found ${response.data.result.length} routines');
          
          // Sort routines by creation date (most recent first)
          var sortedRoutines = response.data.result.toList();
          sortedRoutines.sort((a, b) {
            final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA); // Most recent first
          });
          
          // Take only the most recent 3 items
          final routineItems = sortedRoutines.take(3).toList();
          print('Showing ${routineItems.length} most recent routines');
          
          // Convert API data to the format expected by the UI
          final formattedData = routineItems.map((item) {
            print('Adding routine: ${item.category} - ${item.product.productName}');
            return {
              'icon': _getCategoryIcon(item.category),
              'title': item.category,
              'description': item.product.productName,
              'time': _getTimeForCategory(item.category),
              'isCompleted': RxBool(false),
            };
          }).toList();
          
          routineData.assignAll(formattedData);
          print('Routine data updated with ${routineData.length} items');
        }
      } else {
        print('API request failed - response success: ${response.success}');
        routineData.clear();
      }
    } catch (e) {
      print('Error fetching routine data: $e');
      // Clear routine data if API fails
      routineData.clear();
    } finally {
      isLoading.value = false;
      print('Final routine data length: ${routineData.length}');
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

  String _getTimeForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'skin':
      case 'skincare':
        return '6:30 AM';
      case 'sun cream':
        return '7:00 AM';
      case 'lotion':
        return '6:45 AM';
      case 'serum':
        return '6:35 AM';
      default:
        return '6:30 AM';
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
    print('Routine data cleared');
  }

  // Method to check if user is authenticated
  Future<bool> checkAuthentication() async {
    final token = await ApiService.getAccessToken();
    final isAuthenticated = token != null && token.isNotEmpty;
    print('User authenticated: $isAuthenticated');
    return isAuthenticated;
  }

  // Debug method to check full authentication state
  Future<void> debugAuthenticationState() async {
    print('=== DEBUG: Full Authentication State ===');
    await checkAuthentication();
    print('Current routine data length: ${routineData.length}');
    print('Is loading: ${isLoading.value}');
    
    // Try to fetch data again
    print('Attempting to fetch routine data...');
    await fetchHomeRoutineData();
  }
}