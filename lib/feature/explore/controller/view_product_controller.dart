
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineDetails {
  String startDate;
  String endDate;
  String frequency;

  RoutineDetails({
    required this.startDate,
    required this.endDate,
    required this.frequency,
  });

  // Convert to JSON map
  Map<String, dynamic> toJson() => {
        'startDate': startDate,
        'endDate': endDate,
        'frequency': frequency,
      };

  // Create from JSON map
  factory RoutineDetails.fromJson(Map<String, dynamic> json) {
    return RoutineDetails(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      frequency: json['frequency'] as String,
    );
  }
}

class ViewProductController extends GetxController {
   // Reactive product data
  final RxMap<String, dynamic> productDataview = <String, dynamic>{}.obs;
  // Reactive list of images
  final RxList<String> imagePath = <String>[].obs;
  // Current image index for gallery
  final RxInt currentIndex = 0.obs;
  
 

  void nextImage() {
    currentIndex.value = (currentIndex.value + 1) % imagePath.length;
  }

  void prevImage() {
    currentIndex.value = (currentIndex.value - 1 + imagePath.length) % imagePath.length;
  }



  final RxList<String> howToUseIt = [
    "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
    "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
    "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
    "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
  ].obs;

  final RxMap<String, dynamic> viewRoutingProductView = {
    "productName": "Essence Sun’s Cream SPF45",
    "Description": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production."
  }.obs;

  final RxList<String> usesdirection = [
    "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
    "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
    "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
    "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
  ].obs;
  final RxList<String>mynote = [
    "Taking care of your skin isn't just about appearance — it's about feeling confident, healthy, and in tune with yourself. This app is designed to help you understand your skin's unique needs, track your progress, and build a routine that actually works for you. Whether you're managing breakouts, dryness, or just looking to maintain a healthy glow, we’re here to support you every step of the way. Your skin is yours — let’s help it thrive."
  ].obs;

  // Observable for routine details
  final Rx<RoutineDetails> routineDetails = RoutineDetails(
    startDate: "15 Jan, 2025",
    endDate: "25 Mar, 2025",
    frequency: "2 times",
  ).obs;
    Future<void> fetchProductDetails(String id) async {
    try {
      EasyLoading.show(status: "Loading product...", maskType: EasyLoadingMaskType.black);

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        EasyLoading.showError("Please login again");
        return;
      }

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/product/details/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"] != null) {
          productDataview.value = data["data"];

          // Build image list with proper URLs
          imagePath.value = List<String>.from(
            (data["data"]["image"] ?? []).map((img) => "${Urls.imageurl}$img")
          );

          // Reset the current image index
          currentIndex.value = 0;

          EasyLoading.dismiss();
        } else {
          EasyLoading.showError("Failed to load product details");
        }
      } else {
        EasyLoading.showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError("Error loading product details");
      print("Error fetching product details: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

}