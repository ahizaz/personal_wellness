import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';

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

  var progress = 0.obs;
  var progressMessage = 'Setting up your routine...'.obs;

  final RxList<RoutineItem> routines = <RoutineItem>[].obs;

void submitRoutine() async {
  final colors = [
    const Color(0xffFFF8E6),
    const Color(0xffE6F7F7),
    const Color(0xffF2E6FF),
    const Color(0xffE6FFE6),
  ];

  // Add only one RoutineItem using the first selected time (if any)
  if (selectedTimes.isNotEmpty && productName.value.isNotEmpty) {
    final color = colors[routines.length % colors.length];
    routines.add(
      RoutineItem(
        productName: productName.value,
        backgroundColor: color,
        time: selectedTimes.first, // Use the first selected time
      ),
    );
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
  startDate.value = null;
  endDate.value = null;
  selectedOrder.value = 0;
  selectedEveningOrder.value = 0;
  selectedTimes.clear();
  instructionText.value = '';
  productName.value = '';
  instructionController.clear();

  Get.back();
  final BottomNavcontroller navController = Get.find();
  Get.off(() => BottomNavbar());
  navController.changeIndex(2);
}
  @override
  void onInit() {
    super.onInit();
    // Don't use Get.arguments here as it can conflict with AddToRoutine's arguments handling
    // Product name will be set via setProductName() from AddToRoutine
  }
}