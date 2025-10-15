import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:personal_wellness/core/urls/urls.dart';

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
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      notifications.refresh();
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

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

      final uri = Uri.parse(Urls.notificationsGetAll);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final success = decoded['success'] == true;
        if (!success) {
          errorMessage.value = (decoded['message'] ?? 'Failed to load').toString();
          notifications.clear();
          return;
        }

        final data = decoded['data'] as Map<String, dynamic>?;
        final List<dynamic> result = (data?['result'] as List<dynamic>?) ?? <dynamic>[];
        final items = result.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>)).toList();
        
        // Add sample notifications if the list is empty (for demo purposes)
        if (items.isEmpty) {
          final sampleNotifications = _getSampleNotifications();
          notifications.assignAll(sampleNotifications);
        } else {
          notifications.assignAll(items);
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Session expired. Please sign in again.';
        notifications.clear();
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
        notifications.clear();
      }
    } catch (e) {
      debugPrint('Notifications fetch error: $e');
      errorMessage.value = 'Something went wrong. Please try again.';
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
  }

  void removeNotification(String notificationId) {
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
}