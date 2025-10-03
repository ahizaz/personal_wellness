import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/urls/urls.dart';

class PersonalizationService {
  // Use {{URL}} placeholder format
  static const String apiUrl = '{{URL}}/personalisation/create';

  // Test network connectivity
  static Future<bool> testConnection() async {
    try {
      debugPrint('=== TESTING NETWORK CONNECTION ===');
      debugPrint('Testing URL: ${Urls.baseUrl}');
      final response = await http.get(
        Uri.parse(Urls.baseUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      debugPrint('Connection Test Status: ${response.statusCode}');
      debugPrint('=================================');
      return true;
    } catch (e) {
      debugPrint('=== CONNECTION TEST FAILED ===');
      debugPrint('Error: $e');
      debugPrint('=============================');
      return false;
    }
  }

  static Future<bool> createPersonalization({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String type,
    required String skinLevel,
  }) async {
    debugPrint('=== PERSONALIZATION API CALL STARTED ===');
    debugPrint('Base URL: ${Urls.baseUrl}');
    debugPrint('Full URL: ${Urls.baseUrl}/personalisation/create');
    debugPrint('Template: {{URL}}/personalisation/create');
    debugPrint('Method: POST');
    
    try {
      // Get access token
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userId = prefs.getString('userId');
      
      debugPrint('=== TOKEN CHECK ===');
      debugPrint('Access Token: ${accessToken != null ? "${accessToken.substring(0, accessToken.length < 20 ? accessToken.length : 20)}..." : "NULL"}');
      debugPrint('Token Length: ${accessToken?.length ?? 0}');
      debugPrint('User ID: $userId');
      debugPrint('SharedPreferences Keys: ${prefs.getKeys()}');
      debugPrint('==================');
      
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('ERROR: No access token found!');
        return false;
      }

      // Prepare request body
      final requestBody = {
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'type': type,
        'skinLevel': skinLevel,
      };

      debugPrint('=== REQUEST BODY ===');
      debugPrint('Raw JSON: ${jsonEncode(requestBody)}');
      debugPrint('==================');

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      debugPrint('=== REQUEST HEADERS ===');
      debugPrint('Content-Type: ${headers['Content-Type']}');
      debugPrint('Authorization: Bearer ${accessToken.substring(0, 20)}...');
      debugPrint('=====================');

      // Make the request
      debugPrint('=== MAKING HTTP REQUEST ===');
      debugPrint('Final URL: ${Urls.personalizationCreate}');
      debugPrint('Resolved to: http://10.10.12.25:5005/api/v1/personalisation/create');
      final response = await http.post(
        Uri.parse(Urls.personalizationCreate),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      debugPrint('=== RESPONSE RECEIVED ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.reasonPhrase}');
      debugPrint('Response Headers: ${response.headers}');
      debugPrint('========================');

      debugPrint('=== RESPONSE BODY ===');
      debugPrint('Raw Response: ${response.body}');
      debugPrint('Body Length: ${response.body.length}');
      debugPrint('====================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = jsonDecode(response.body);
          debugPrint('=== PARSED RESPONSE DATA ===');
          debugPrint('Response Type: ${responseData.runtimeType}');
          debugPrint('Response Keys: ${responseData is Map ? responseData.keys.toList() : 'Not a Map'}');
          debugPrint('Full Response: $responseData');
          debugPrint('============================');
          
          return true;
        } catch (e) {
          debugPrint('=== JSON PARSE ERROR ===');
          debugPrint('Error: $e');
          debugPrint('Raw Body: ${response.body}');
          debugPrint('=======================');
          
          // Even if JSON parsing fails, if status is success, consider it successful
          return true;
        }
      } else {
        debugPrint('=== API ERROR ===');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Error Body: ${response.body}');
        debugPrint('================');
        
        try {
          final errorData = jsonDecode(response.body);
          debugPrint('=== PARSED ERROR DATA ===');
          debugPrint('Error Response: $errorData');
          debugPrint('==========================');
        } catch (e) {
          debugPrint('Failed to parse error response: $e');
        }
        
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('=== EXCEPTION OCCURRED ===');
      debugPrint('Exception Type: ${e.runtimeType}');
      debugPrint('Exception Message: $e');
      debugPrint('Stack Trace: $stackTrace');
      debugPrint('=========================');
      return false;
    }
  }
}