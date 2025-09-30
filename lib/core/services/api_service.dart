import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:flutter/material.dart';

class ApiService {
  static Future<bool> addProductToRoutine({
    required String productId,
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    required int morningOrder,
    required List<String> morningTimeOfDay,
    required int eveningOrder,
    required List<String> eveningTimeOfDay,
    required String additionalIntroduction,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        debugPrint('No access token found');
        return false;
      }

      final body = {
        "product": productId,
        "category": category,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "morningOrder": morningOrder,
        "morningTimeOfDay": morningTimeOfDay,
        "eveningOrder": eveningOrder,
        "eveningTimeOfDay": eveningTimeOfDay,
        "additionalIntroduction": additionalIntroduction,
      };

      debugPrint('=== POST API Call ===');
      debugPrint('URL: ${Urls.baseUrl}/add-routine/add');
      debugPrint('Headers: {Content-Type: application/json, Authorization: Bearer $accessToken}');
      debugPrint('Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/add-routine/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      debugPrint('=== API Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('=== Success ===');
        debugPrint('Response Data: $data');
        return true;
      } else {
        debugPrint('=== Error ===');
        debugPrint('Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('=== Exception ===');
      debugPrint('Error adding product to routine: $e');
      return false;
    }
  }
}