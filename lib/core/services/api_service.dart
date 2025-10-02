import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/core/models/routine_home_model.dart';
import 'package:personal_wellness/core/models/product_details_model.dart';
import 'package:flutter/material.dart';

class ApiService {
  // Helper method to check if access token exists
  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final userId = prefs.getString('userId');
      debugPrint('=== Authentication Check ===');
      debugPrint('Access Token exists: ${token != null}');
      debugPrint('Access Token length: ${token?.length ?? 0}');
      debugPrint('User ID exists: ${userId != null}');
      debugPrint('User ID: $userId');
      debugPrint('Token preview: ${token != null ? '${token.substring(0, token.length > 20 ? 20 : token.length)}...' : 'null'}');
      
      // Check if both token and userId exist (as required by splash screen)
      if (token != null && userId != null) {
        debugPrint('User is fully authenticated');
        return token;
      } else {
        debugPrint('User authentication incomplete - missing ${token == null ? 'token' : ''} ${userId == null ? 'userId' : ''}');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting access token: $e');
      return null;
    }
  }

  static Future<bool> addProductToRoutine({
    required String productId,
    required String category,
    required DateTime startDate,
    required DateTime endDate,
    int? morningOrder,
    List<String>? morningTimeOfDay,
    int? eveningOrder,
    List<String>? eveningTimeOfDay,
    required String additionalIntroduction,
  }) async {
    try {
      final accessToken = await getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token found for add routine');
        return false;
      }

      final body = <String, dynamic>{
        "product": productId,
        "category": category,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "additionalIntroduction": additionalIntroduction,
      };

      // Add morning data only if provided
      if (morningOrder != null && morningTimeOfDay != null && morningTimeOfDay.isNotEmpty) {
        body["morningOrder"] = morningOrder;
        body["morningTimeOfDay"] = morningTimeOfDay;
      }

      // Add evening data only if provided
      if (eveningOrder != null && eveningTimeOfDay != null && eveningTimeOfDay.isNotEmpty) {
        body["eveningOrder"] = eveningOrder;
        body["eveningTimeOfDay"] = eveningTimeOfDay;
      }

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

  static Future<RoutineHomeModel?> getHomeRoutineData() async {
    try {
      final accessToken = await getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token found - user not logged in for get home routine');
        // Return null to indicate authentication issue
        return null;
      }

      debugPrint('=== GET API Call ===');
      debugPrint('URL: ${Urls.baseUrl}/add-routine/get-for-home');
      debugPrint('Headers: {Content-Type: application/json, Authorization: Bearer $accessToken}');

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/add-routine/get-for-home'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('=== API Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('=== Success ===');
        debugPrint('Response Data: $data');
        return RoutineHomeModel.fromJson(data);
      } else {
        debugPrint('=== Error ===');
        debugPrint('Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('=== Exception ===');
      debugPrint('Error fetching home routine data: $e');
      return null;
    }
  }

  // Product Details API
  static Future<ProductDetailsModel?> getProductDetails(String productId) async {
    try {
      final accessToken = await getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token found for product details');
        return null;
      }

      final url = '${Urls.getProductDetails}/$productId';

      debugPrint('=== GET Product Details API Call ===');
      debugPrint('URL: $url');
      debugPrint('Headers: {Content-Type: application/json, Authorization: Bearer $accessToken}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('=== API Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('=== Success ===');
        debugPrint('Response Data: $data');
        return ProductDetailsModel.fromJson(data);
      } else {
        debugPrint('=== Error ===');
        debugPrint('Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('=== Exception ===');
      debugPrint('Error fetching product details: $e');
      return null;
    }
  }
}