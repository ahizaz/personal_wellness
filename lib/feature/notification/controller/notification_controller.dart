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

  NotificationItem({required this.id, required this.title, required this.body});

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: (json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
    );
  }
}

class NotificationController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
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
        notifications.assignAll(items);
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
}


