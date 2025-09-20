
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

// class RoutineDetails {
//   String startDate;
//   String endDate;
//   String frequency;

//   RoutineDetails({
//     required this.startDate,
//     required this.endDate,
//     required this.frequency,
//   });

//   // Convert to JSON map
//   Map<String, dynamic> toJson() => {
//         'startDate': startDate,
//         'endDate': endDate,
//         'frequency': frequency,
//       };

//   // Create from JSON map
//   factory RoutineDetails.fromJson(Map<String, dynamic> json) {
//     return RoutineDetails(
//       startDate: json['startDate'] as String,
//       endDate: json['endDate'] as String,
//       frequency: json['frequency'] as String,
//     );
//   }
// }

// class ViewProductController extends GetxController {
//   final RxInt currentIndex = 0.obs;
//   final List<String> imagePath = [
//     "assets/images/produt_details_1.png",
//     "assets/images/product_details_2.png",
//     "assets/images/product_details_3.png",
//   ];

//   void nextImage() {
//     currentIndex.value = (currentIndex.value + 1) % imagePath.length;
//   }

//   void prevImage() {
//     currentIndex.value = (currentIndex.value - 1 + imagePath.length) % imagePath.length;
//   }

//   final RxMap<String, dynamic> productDataview = {
//     "productName": "Essence Sun’s Cream SPF45",
//     "ingredients": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production. Hyperpigmentation\nappear as dark spots ",
//   }.obs;

//   final RxList<String> howToUseIt = [
//     "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
//     "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
//     "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
//     "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
//   ].obs;

//   final RxMap<String, dynamic> viewRoutingProductView = {
//     "productName": "Essence Sun’s Cream SPF45",
//     "Description": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production."
//   }.obs;

//   final RxList<String> usesdirection = [
//     "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
//     "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
//     "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
//     "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
//   ].obs;
//   final RxList<String>mynote = [
//     "Taking care of your skin isn't just about appearance — it's about feeling confident, healthy, and in tune with yourself. This app is designed to help you understand your skin's unique needs, track your progress, and build a routine that actually works for you. Whether you're managing breakouts, dryness, or just looking to maintain a healthy glow, we’re here to support you every step of the way. Your skin is yours — let’s help it thrive."
//   ].obs;

//   // Observable for routine details
//   final Rx<RoutineDetails> routineDetails = RoutineDetails(
//     startDate: "15 Jan, 2025",
//     endDate: "25 Mar, 2025",
//     frequency: "2 times",
//   ).obs;
// }

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

  Map<String, dynamic> toJson() => {
        'startDate': startDate,
        'endDate': endDate,
        'frequency': frequency,
      };

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

  // Network or asset images
  final RxList<String> imageUrls = <String>[
    "assets/images/produt_details_1.png",
    "assets/images/product_details_2.png",
    "assets/images/product_details_3.png",
  ].obs;
   
  void nextImage() {
    if (imageUrls.isEmpty) return;
    currentIndex.value = (currentIndex.value + 1) % imageUrls.length;
  }

  void prevImage() {
    if (imageUrls.isEmpty) return;
    currentIndex.value = (currentIndex.value - 1 + imageUrls.length) % imageUrls.length;
  }

  final RxMap<String, dynamic> productDataview = {
    "productName": "Essence Sun’s Cream SPF45",
    "ingredients": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production. Hyperpigmentation\nappear as dark spots ",
  }.obs;

  final RxList<String> howToUseIt = <String>[
    "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
    "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
    "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
    "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
  ].obs;

  final RxMap<String, dynamic> viewRoutingProductView = {
    "productName": "Essence Sun’s Cream SPF45",
    "Description": "Consists of pimples, blackheads, and cysts,\noften caused by blocked pores, bacteria, and\nexcess oil production."
  }.obs;

  final RxList<String> usesdirection = <String>[
    "Apply generously 15–20 minutes before sun exposure to allow proper absorption and maximum protection.",
    "Use as the final step in your morning skincare routine, after moisturizer and any treatment products.",
    "Reapply every 2 hours, especially after sweating, swimming, or towel drying.",
    "Use daily, even on cloudy days, to help prevent sun damage and reduce the risk of hyperpigmentation and premature aging",
  ].obs;

  final RxList<String> mynote = <String>[
    "Taking care of your skin isn't just about appearance — it's about feeling confident, healthy, and in tune with yourself. This app is designed to help you understand your skin's unique needs, track your progress, and build a routine that actually works for you. Whether you're managing breakouts, dryness, or just looking to maintain a healthy glow, we’re here to support you every step of the way. Your skin is yours — let’s help it thrive."
  ].obs;

  final Rx<RoutineDetails> routineDetails = RoutineDetails(
    startDate: "15 Jan, 2025",
    endDate: "25 Mar, 2025",
    frequency: "2 times",
  ).obs;

  final RxString productId = ''.obs;

  // Consume payload from Get.arguments
  void applyProductArg(Map<String, dynamic> args) {
    if (args["id"] != null) productId.value = args["id"].toString();
    if (args["title"] != null) productDataview["productName"] = args["title"];

    if (args["ingredients"] != null && (args["ingredients"] as String).isNotEmpty) {
      productDataview["ingredients"] = args["ingredients"];
    }

    if (args["howToUse"] is List && (args["howToUse"] as List).isNotEmpty) {
      howToUseIt.assignAll((args["howToUse"] as List).map((e) => e.toString()));
    }

    if (args["images"] is List && (args["images"] as List).isNotEmpty) {
      imageUrls.assignAll((args["images"] as List).map((e) => e.toString()));
      currentIndex.value = 0;
    }
  }
}