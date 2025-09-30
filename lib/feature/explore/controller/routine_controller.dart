import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/core/services/api_service.dart';

class RoutineItem {
  final String productName;
  final Color backgroundColor;
  final String time; // ✅ Field to store the time

  RoutineItem({
    required this.productName,
    required this.backgroundColor,
    required this.time, // ✅ Updated constructor
  });
}

class RoutineController extends GetxController {
  var selectedCategory = ''.obs;
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  var startFocused = false.obs;
  var endFocused = false.obs;
  var selectedMinute = 0.obs;
  var selectedSecond = 0.obs;
  var selectedAmPm = "AM".obs;
  var selectedTimes = <String>[].obs;
  final TextEditingController instructionController = TextEditingController();
  final RxString productName = ''.obs;
  final RxString productId = ''.obs;

  var selectedOrder = 0.obs;
  var selectedEveningOrder = 0.obs;
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

  final RxString instructionText = ''.obs;

  bool get isFormValid {
    return startDate.value != null &&
        endDate.value != null &&
        selectedOrder.value != 0 &&
        selectedEveningOrder.value!=0&&
        selectedTimes.isNotEmpty &&
        instructionText.value.trim().isNotEmpty;
  }

  void setProductName(String name) {
    productName.value = name;
  }

  void setProductId(String id) {
    productId.value = id;
  }

  void setProductData(String name, String id) {
    productName.value = name;
    productId.value = id;
  }

  var progress = 0.obs;
  var progressMessage = 'Setting up your routine...'.obs;

  final RxList<RoutineItem> routines = <RoutineItem>[].obs;

void submitRoutine() async {
  try {
    progress.value = 0;
    progressMessage.value = 'Setting up your routine';

    // Debug print all the data being sent
    debugPrint('=== Submitting Routine ===');
    debugPrint('Product ID: ${productId.value}');
    debugPrint('Product Name: ${productName.value}');
    debugPrint('Category: ${selectedCategory.value}');
    debugPrint('Start Date: ${startDate.value}');
    debugPrint('End Date: ${endDate.value}');
    debugPrint('Morning Order: ${selectedOrder.value}');
    debugPrint('Evening Order: ${selectedEveningOrder.value}');
    debugPrint('Selected Times: ${selectedTimes.toList()}');
    debugPrint('Instructions: ${instructionText.value}');

    await Future.delayed(const Duration(seconds: 1));
    progress.value = 50;
    progressMessage.value = 'Submitting';

    // Make API call
    final success = await ApiService.addProductToRoutine(
      productId: productId.value,
      category: selectedCategory.value.isNotEmpty ? selectedCategory.value : "Skincare",
      startDate: startDate.value!,
      endDate: endDate.value!,
      morningOrder: selectedOrder.value,
      morningTimeOfDay: selectedTimes.toList(),
      eveningOrder: selectedEveningOrder.value,
      eveningTimeOfDay: selectedTimes.toList(), // Using same times for now
      additionalIntroduction: instructionText.value,
    );

    await Future.delayed(const Duration(seconds: 1));
    progress.value = 75;
    progressMessage.value = 'Almost done';

    if (success) {
      // Add to local routine list for immediate UI update
      final colors = [
        const Color(0xffFFF8E6),
        const Color(0xffE6F7F7),
        const Color(0xffF2E6FF),
        const Color(0xffE6FFE6),
      ];

      if (selectedTimes.isNotEmpty && productName.value.isNotEmpty) {
        final color = colors[routines.length % colors.length];
        routines.add(
          RoutineItem(
            productName: productName.value,
            backgroundColor: color,
            time: selectedTimes.first,
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 1));
      progress.value = 100;
      progressMessage.value = 'Routine added successfully!';
    } else {
      progress.value = 100;
      progressMessage.value = 'Failed to add routine';
    }

    await Future.delayed(const Duration(seconds: 1));

    // Reset form
    selectedCategory.value = '';
    startDate.value = null;
    endDate.value = null;
    selectedOrder.value = 0;
    selectedEveningOrder.value = 0;
    selectedTimes.clear();
    instructionText.value = '';
    productName.value = '';
    productId.value = '';
    instructionController.clear();

    Get.back();
    final BottomNavcontroller navController = Get.find();
    Get.off(() => BottomNavbar());
    navController.changeIndex(2);
  } catch (e) {
    debugPrint('Error in submitRoutine: $e');
    progress.value = 100;
    progressMessage.value = 'Error occurred';
  }
}
  @override
  void onInit() {
    super.onInit();
    // Don't use Get.arguments here as it can conflict with AddToRoutine's arguments handling
    // Product name will be set via setProductName() from AddToRoutine
  }
}