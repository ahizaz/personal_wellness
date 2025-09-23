import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';

class RoutineItem {
  final String productName;
  final Color backgroundColor;
  final String time;
  RoutineItem({
    required this.productName,
    required this.backgroundColor,
    required this.time,
  });
}

class RoutineController extends GetxController {
  var selectedCategory = ''.obs;
  var productId = ''.obs;
  void setProductId(String id) => productId.value = id;

  var productName = ''.obs;
  void setProductName(String name) => productName.value = name;

  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  var startFocused = false.obs;
  var endFocused = false.obs;
  var selectedMinute = 0.obs;
  var selectedSecond = 0.obs;
  var selectedAmPm = "AM".obs;
  var selectedTimes = <String>[].obs;
  var selectedOrder = 0.obs;
  var selectedEveningOrder = 0.obs;
  var instructionText = ''.obs;
  var progress = 0.obs;
  var progressMessage = 'Setting up your routine...'.obs;
  var routines = <RoutineItem>[].obs;

  final List<String> availableTimes = [
    '6:00 am', '6:15 am', '6:20 am',
    '6:25 am', '6:30 am', '6:45 am',
  ];
  final List<String> availableeveningTimes = [
    '7:00 am', '7:15 am', '7:20 am',
    '7:25 am', '7:30 am', '7:45 am',
  ];

  var visibleOrders = 3.obs;
  var visibleEvening = 3.obs;

  void toggleTimeSelection(String time) {
    if (selectedTimes.contains(time)) {
      selectedTimes.remove(time);
    } else {
      selectedTimes.add(time);
    }
  }

  bool get isFormValid {
    return startDate.value != null &&
        endDate.value != null &&
        selectedOrder.value != 0 &&
        selectedEveningOrder.value != 0 &&
        selectedTimes.isNotEmpty &&
        instructionText.value.trim().isNotEmpty &&
        productId.value.isNotEmpty;
  }

  Future<void> submitRoutine() async {
    final colors = [
      const Color(0xffFFF8E6),
      const Color(0xffE6F7F7),
      const Color(0xffF2E6FF),
      const Color(0xffE6FFE6),
    ];

    if (selectedTimes.isNotEmpty) {
      final color = colors[routines.length % colors.length];
      routines.add(
        RoutineItem(
          productName: productName.value,
          backgroundColor: color,
          time: selectedTimes.first,
        ),
      );
    }

    final body = {
      "product": productId.value,
      "category": selectedCategory.value,
      "startDate": startDate.value?.toUtc().toIso8601String(),
      "endDate": endDate.value?.toUtc().toIso8601String(),
      "morningOrder": selectedOrder.value,
      "morningTimeOfDay": selectedTimes,
      "eveningOrder": selectedEveningOrder.value,
      "eveningTimeOfDay": selectedTimes,
      "additionalIntroduction": instructionText.value,
    };

    debugPrint('Routine POST body: ${jsonEncode(body)}');

    EasyLoading.show(status: "Submitting routine...", maskType: EasyLoadingMaskType.black);

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      if (accessToken == null) {
        EasyLoading.showError("Please login again");
        debugPrint("No access token found.");
        return;
      }

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/add-routine/add"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(body),
      );

      debugPrint('Routine POST response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Routine added successfully!");
      } else {
        EasyLoading.showError("Error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError("Failed to submit routine");
      debugPrint('Routine POST exception: $e');
    } finally {
      EasyLoading.dismiss();
    }

    progress.value = 0;
    progressMessage.value = 'Setting up your routine';
    await Future.delayed(const Duration(seconds: 1));
    progress.value = 65;
    progressMessage.value = 'Almost done';
    await Future.delayed(const Duration(seconds: 2));
    progress.value = 100;
    progressMessage.value = 'Done';
    await Future.delayed(const Duration(seconds: 1));

    selectedCategory.value = '';
    productId.value = '';
    productName.value = '';
    startDate.value = null;
    endDate.value = null;
    selectedOrder.value = 0;
    selectedEveningOrder.value = 0;
    selectedTimes.clear();
    instructionText.value = '';

    Get.back();
    final BottomNavcontroller navController = Get.find();
    Get.off(() => BottomNavbar());
    navController.changeIndex(2);
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    String? passedProductId;
    String? passedProductName;
    if (args is Map<String, dynamic>) {
      passedProductId = args['productId'];
      passedProductName = args['productName'];
    } else if (args is String) {
      passedProductId = args;
      passedProductName = null;
    }
    if (passedProductName != null) productName.value = passedProductName;
    if (passedProductId != null) productId.value = passedProductId;
  }
}