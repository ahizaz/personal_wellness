
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

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
  final RxInt currentIndex = 0.obs;
  final List<String> imagePath = [
    "assets/images/produt_details_1.png",
    "assets/images/product_details_2.png",
    "assets/images/product_details_3.png",
  ];

  void nextImage() {
    currentIndex.value = (currentIndex.value + 1) % imagePath.length;
  }

  void prevImage() {
    currentIndex.value = (currentIndex.value - 1 + imagePath.length) % imagePath.length;
  }

  final RxMap<String, dynamic> productDataview = {
    "productName": "Essence Sun’s Cream SPF45",
    "ingredients": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production. Hyperpigmentation\nappear as dark spots ",
  }.obs;

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

  // Observable for routine details
  final Rx<RoutineDetails> routineDetails = RoutineDetails(
    startDate: "15 Jan, 2025",
    endDate: "25 Mar, 2025",
    frequency: "2 times",
  ).obs;
}