// lib/feature/notification/controller/notification_controller.dart (lines 2-367)
// IMPORTANT: Always display this snippet in chat as markdown in the language provided.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String timestamp;
  final bool isRead;
  final String type; // 'like', 'comment', 'follow', 'routine', 'reminder'
  final String? avatarUrl;
  final String? actionText;

  NotificationItem({
    required this.id, 
    required this.title, 
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.type = 'general',
    this.avatarUrl,
    this.actionText,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: (json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      timestamp: (json['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
      isRead: json['isRead'] ?? false,
      type: (json['type'] ?? 'general').toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      actionText: json['actionText']?.toString(),
    );
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? timestamp,
    bool? isRead,
    String? type,
    String? avatarUrl,
    String? actionText,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      actionText: actionText ?? this.actionText,
    );
  }
}

class NotificationController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final notifications = <NotificationItem>[].obs;
  final readNotificationIds = <String>{}.obs;
  late Timer _timer;

  // Keep routine filter state here so fetchNotifications (and pull-to-refresh) preserve user's selection
  bool includeMorningForRoutines = false;
  bool includeEveningForRoutines = true;

  @override
  void onInit() {
    super.onInit();
    loadReadIds();
    fetchNotifications();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      fetchNotifications();
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  Future<void> loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('read_notification_ids') ?? [];
    readNotificationIds.assignAll(list.toSet());
  }

  Future<void> saveReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('read_notification_ids', readNotificationIds.toList());
  }

  void _updateReadStatus() {
    for (int i = 0; i < notifications.length; i++) {
      if (readNotificationIds.contains(notifications[i].id)) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    notifications.refresh();
  }

  /// Public setter used by the settings controller when the user taps Done.
  void setRoutineFilters({required bool includeMorning, required bool includeEvening}) {
    includeMorningForRoutines = includeMorning;
    includeEveningForRoutines = includeEvening;
  }

  /// Fetch push-notifications from server, then also fetch routines and merge notifications
  /// according to includeMorningForRoutines / includeEveningForRoutines.
  Future<void> fetchNotifications() async {
    errorMessage.value = '';
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        errorMessage.value = 'Not authenticated. Please sign in again.';
        notifications.clear();
        return;
      }

      // 1) Fetch push notifications
      final uri = Uri.parse(Urls.notificationsGetAll);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      List<NotificationItem> pushItems = [];

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final success = decoded['success'] == true;
        if (!success) {
          errorMessage.value = (decoded['message'] ?? 'Failed to load').toString();
        } else {
          final data = decoded['data'] as Map<String, dynamic>?;
          final List<dynamic> result = (data?['result'] as List<dynamic>?) ?? <dynamic>[];
          pushItems = result.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>)).toList();
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Session expired. Please sign in again.';
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }

      // 2) Fetch routines and build routine notifications according to user's selection
      final routineItems = await _fetchRoutinesAndBuildNotifications(
        includeMorning: includeMorningForRoutines,
        includeEvening: includeEveningForRoutines,
        token: token,
      );

      // 3) Merge pushItems and routineItems, keep uniqueness by id (routine ids have suffixes)
      final Map<String, NotificationItem> merged = {};

      for (final n in pushItems) {
        merged[n.id] = n;
      }
      for (final n in routineItems) {
        // If a push notification has same id as constructed routine item we keep push version (push likely has metadata)
        merged.putIfAbsent(n.id, () => n);
      }

      final List<NotificationItem> finalList = merged.values.toList()
        ..sort((a, b) {
          // Try to sort by timestamp desc (newest first)
          try {
            return DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp));
          } catch (_) {
            return 0;
          }
        });

      // If still empty, add sample notifications for demo
      if (finalList.isEmpty) {
        finalList.addAll(_getSampleNotifications());
      }

      notifications.assignAll(finalList);
      _updateReadStatus();
    } catch (e) {
      debugPrint('Notifications fetch error: $e');
      errorMessage.value = 'Something went wrong. Please try again.';
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Internal helper - fetch routines and build NotificationItem list.
  Future<List<NotificationItem>> _fetchRoutinesAndBuildNotifications({
    required bool includeMorning,
    required bool includeEvening,
    required String token,
  }) async {
    try {
      final uri = Uri.parse(Urls.addRoutineGetAll);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return [];
      }

      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final success = decoded['success'] == true;
      if (!success) {
        return [];
      }

      final data = decoded['data'] as Map<String, dynamic>?;
      final List<dynamic> result = (data?['result'] as List<dynamic>?) ?? <dynamic>[];

      final List<NotificationItem> built = [];

      for (final raw in result) {
        if (raw is! Map<String, dynamic>) continue;

        final id = (raw['_id'] ?? '').toString();
        final createdAt = (raw['createdAt'] ?? DateTime.now().toIso8601String()).toString();
        final productName = (raw['product'] != null && raw['product']['productName'] != null)
            ? raw['product']['productName'].toString()
            : 'Product';

        final List<dynamic> morningTimes = (raw['morningTimeOfDay'] as List<dynamic>?) ?? [];
        final List<dynamic> eveningTimes = (raw['eveningTimeOfDay'] as List<dynamic>?) ?? [];

        if (includeMorning) {
          for (final t in morningTimes) {
            final timeStr = t?.toString() ?? '';
            built.add(NotificationItem(
              id: '${id}_morning_${timeStr}',
              title: productName,
              body: timeStr.isNotEmpty
                  ? 'Morning product scheduled at $timeStr'
                  : 'Morning product scheduled',
              timestamp: createdAt,
              isRead: false,
              type: 'reminder',
              actionText: 'Start Routine',
            ));
          }
        }

        if (includeEvening) {
          for (final t in eveningTimes) {
            final timeStr = t?.toString() ?? '';
            built.add(NotificationItem(
              id: '${id}_evening_${timeStr}',
              title: productName,
              body: timeStr.isNotEmpty
                  ? 'Evening product scheduled at $timeStr'
                  : 'Evening product scheduled',
              timestamp: createdAt,
              isRead: false,
              type: 'reminder',
              actionText: 'Start Routine',
            ));
          }
        }
      }

      return built;
    } catch (e) {
      debugPrint('Routines fetch error: $e');
      return [];
    }
  }

  void markAsRead(String notificationId) {
    readNotificationIds.add(notificationId);
    saveReadIds();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    for (var n in notifications) {
      readNotificationIds.add(n.id);
    }
    saveReadIds();
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
  }

  void removeNotification(String notificationId) {
    readNotificationIds.remove(notificationId);
    saveReadIds();
    notifications.removeWhere((n) => n.id == notificationId);
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationItem> _getSampleNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: '1',
        title: 'Routine Reminder',
        body: 'Time for your morning skincare routine!',
        timestamp: now.subtract(const Duration(minutes: 5)).toIso8601String(),
        isRead: false,
        type: 'reminder',
        actionText: 'Start Routine',
      ),
      NotificationItem(
        id: '2',
        title: 'Weekly Progress',
        body: 'Great job! You\'ve completed 5 routines this week.',
        timestamp: now.subtract(const Duration(hours: 2)).toIso8601String(),
        isRead: false,
        type: 'routine',
        actionText: 'View Progress',
      ),
      NotificationItem(
        id: '3',
        title: 'New Product Recommendation',
        body: 'Based on your skin type, we recommend trying our new vitamin C serum.',
        timestamp: now.subtract(const Duration(hours: 6)).toIso8601String(),
        isRead: true,
        type: 'general',
        actionText: 'Learn More',
      ),
      NotificationItem(
        id: '4',
        title: 'Routine Completed',
        body: 'Congratulations! You\'ve completed your evening routine.',
        timestamp: now.subtract(const Duration(days: 1)).toIso8601String(),
        isRead: true,
        type: 'routine',
        actionText: 'View Details',
      ),
      NotificationItem(
        id: '5',
        title: 'Skin Analysis Update',
        body: 'Your skin analysis shows improvement in hydration levels.',
        timestamp: now.subtract(const Duration(days: 2)).toIso8601String(),
        isRead: true,
        type: 'general',
        actionText: 'View Report',
      ),
    ];
  }

  void handleNotificationAction(NotificationItem item) {
    markAsRead(item.id);

    final actionMessage = item.actionText?.isNotEmpty == true
        ? item.actionText!
        : 'View details';

    switch (item.type) {
      case 'reminder':
      case 'routine':
        // Navigate to Today screen (home page) where routines are shown
        try {
          // Try to find BottomNavcontroller to switch to Today tab
          final bottomNavController = Get.find<BottomNavcontroller>();
          bottomNavController.changeIndex(0); // 0 is typically the Today/Home tab
          Get.back(); // Close notification screen if open
        } catch (e) {
          // Fallback: just show snackbar if navigation controller not found
          Get.snackbar('Routine', '$actionMessage for ${item.title}');
        }
        break;
      case 'like':
      case 'comment':
      case 'follow':
        Get.snackbar('Activity', '$actionMessage for ${item.title}');
        break;
      default:
        Get.snackbar('Notification', actionMessage);
    }
  }
}