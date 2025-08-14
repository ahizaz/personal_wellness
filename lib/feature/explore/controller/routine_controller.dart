// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
// import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';

// class RoutineItem {
//   final String productName;

//   RoutineItem({
//     required this.productName,
//   });
// }

// class RoutineController extends GetxController {
//   var selectedCategory = ''.obs;
//   var startDate = Rx<DateTime?>(null);
//   var endDate = Rx<DateTime?>(null);
//   var startFocused = false.obs;
//   var endFocused = false.obs;
//   var selectedMinute = 0.obs;
//   var selectedSecond = 0.obs;
//   var selectedAmPm = "AM".obs;
//   var selectedTimes = <String>[].obs;
//   final TextEditingController instructionController = TextEditingController();
//   final RxString productName = ''.obs; // New field to store product name
  
//   // Order selection
//   var selectedOrder = 0.obs; // 0 means nothing selected
//   final List<String> availableTimes = [
//     '6:00 am', '6:15 am', '6:20 am',
//     '6:25 am', '6:30 am', '6:45 am',
//     '7:00 pm', '7:15 pm', '7:20 pm',
//     '7:25 pm', '7:30 pm', '7:45 pm',
//   ];

//   // Method to handle selection logic
//   void toggleTimeSelection(String time) {
//     if (selectedTimes.contains(time)) {
//       selectedTimes.remove(time);
//     } else {
//       selectedTimes.add(time);
//     }
//   }

//   final RxString instructionText = ''.obs;

//   bool get isFormValid {
//     return startDate.value != null &&
//         endDate.value != null &&
//         selectedOrder.value != 0 &&
//         selectedTimes.isNotEmpty &&
//         instructionText.value.trim().isNotEmpty;
//   }
// void setProductName(String name) {
//     productName.value = name;
//   }
//   // Add progress-related fields
//   var progress = 0.obs;
//   var progressMessage = 'Setting up your routine...'.obs;

//   final RxList<RoutineItem> routines = <RoutineItem>[].obs;

//   // Submit routine method
//   void submitRoutine() async {
//     routines.add(RoutineItem(productName: productName.value));
//     progress.value = 0;
//     progressMessage.value = 'Setting up your routine';
//     await Future.delayed(const Duration(seconds: 1));
//     progress.value = 65;
//     progressMessage.value = 'Almost done';
//     await Future.delayed(const Duration(seconds: 2));
//     progress.value = 100;
//     progressMessage.value = 'Done';
//     await Future.delayed(const Duration(seconds: 1));
//     // Clear all data
//     selectedCategory.value = '';
//     startDate.value = null;
//     endDate.value = null;
//     selectedOrder.value = 0;
//     selectedTimes.clear();
//     instructionText.value = '';
//     productName.value = '';
//     instructionController.clear();
//     Get.back(); // Close dialog
//     final BottomNavcontroller navController = Get.find();
//     Get.off(() => BottomNavbar());
//     navController.changeIndex(2); // Navigate to explore page
//   }

//   // Initialize with product name from ViewProduct
//   @override
//   void onInit() {
//     super.onInit();
//     final passedProductName = Get.arguments as String?;
//     if (passedProductName != null) {
//       productName.value = passedProductName;
//     }
//   }
  
// }
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
// import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';

// class RoutineItem {
//   final String productName;

//   RoutineItem({
//     required this.productName,
//   });
// }

// class RoutineController extends GetxController {
//   var selectedCategory = ''.obs;
//   var startDate = Rx<DateTime?>(null);
//   var endDate = Rx<DateTime?>(null);
//   var startFocused = false.obs;
//   var endFocused = false.obs;
//   var selectedMinute = 0.obs;
//   var selectedSecond = 0.obs;
//   var selectedAmPm = "AM".obs;
//   var selectedTimes = <String>[].obs;
//   final TextEditingController instructionController = TextEditingController();
//   final RxString productName = ''.obs; // New field to store product name
  
//   // Order selection
//   var selectedOrder = 0.obs; // 0 means nothing selected
//   final List<String> availableTimes = [
//     '6:00 am', '6:15 am', '6:20 am',
//     '6:25 am', '6:30 am', '6:45 am',
//     '7:00 pm', '7:15 pm', '7:20 pm',
//     '7:25 pm', '7:30 pm', '7:45 pm',
//   ];

//   // Method to handle selection logic
//   void toggleTimeSelection(String time) {
//     if (selectedTimes.contains(time)) {
//       selectedTimes.remove(time);
//     } else {
//       selectedTimes.add(time);
//     }
//   }

//   final RxString instructionText = ''.obs;

//   bool get isFormValid {
//     return startDate.value != null &&
//         endDate.value != null &&
//         selectedOrder.value != 0 &&
//         selectedTimes.isNotEmpty &&
//         instructionText.value.trim().isNotEmpty;
//   }
// void setProductName(String name) {
//     productName.value = name;
//   }
//   // Add progress-related fields
//   var progress = 0.obs;
//   var progressMessage = 'Setting up your routine...'.obs;

//   final RxList<RoutineItem> routines = <RoutineItem>[].obs;

//   // Submit routine method
//   void submitRoutine() async {
//     routines.add(RoutineItem(productName: productName.value));
//     progress.value = 0;
//     progressMessage.value = 'Setting up your routine';
//     await Future.delayed(const Duration(seconds: 1));
//     progress.value = 65;
//     progressMessage.value = 'Almost done';
//     await Future.delayed(const Duration(seconds: 2));
//     progress.value = 100;
//     progressMessage.value = 'Done';
//     await Future.delayed(const Duration(seconds: 1));
//     // Clear all data
//     selectedCategory.value = '';
//     startDate.value = null;
//     endDate.value = null;
//     selectedOrder.value = 0;
//     selectedTimes.clear();
//     instructionText.value = '';
//     productName.value = '';
//     instructionController.clear();
//     Get.back(); // Close dialog
//     final BottomNavcontroller navController = Get.find();
//     Get.off(() => BottomNavbar());
//     navController.changeIndex(2); // Navigate to explore page
//   }

//   // Initialize with product name from ViewProduct
//   @override
//   void onInit() {
//     super.onInit();
//     final passedProductName = Get.arguments as String?;
//     if (passedProductName != null) {
//       productName.value = passedProductName;
//     }
//   }
  
// }
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
  final Color backgroundColor; // ✅ নতুন ফিল্ড

  RoutineItem({
    required this.productName,
    required this.backgroundColor,
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
  final List<String> availableTimes = [
    '6:00 am', '6:15 am', '6:20 am',
    '6:25 am', '6:30 am', '6:45 am',
    '7:00 pm', '7:15 pm', '7:20 pm',
    '7:25 pm', '7:30 pm', '7:45 pm',
  ];

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
    // ✅ কালার লিস্ট যেটা picture এর মতো
    final colors = [
      Color(0xffFFF8E6), // হলুদ হালকা
      Color(0xffE6F7F7), // হালকা নীল
      Color(0xffF2E6FF), // হালকা বেগুনি
      Color(0xffE6FFE6), // হালকা সবুজ
    ];

    final color = colors[routines.length % colors.length];

    routines.add(
      RoutineItem(
        productName: productName.value,
        backgroundColor: color, // ✅ কালার সেট
      ),
    );

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
    final passedProductName = Get.arguments as String?;
    if (passedProductName != null) {
      productName.value = passedProductName;
    }
  }
}