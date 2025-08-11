import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Order সিলেকশনের জন্য
  var selectedOrder = 0.obs; // 0 মানে এখনো কিছু সিলেক্ট হয়নি
    final List<String> availableTimes = [
    '6:00 am', '6:15 am', '6:20 am',
    '6:25 am', '6:30 am', '6:45 am',
    '7:00 pm', '7:15 pm', '7:20 pm',
    '7:25 pm', '7:30 pm', '7:45 pm',
  ];

  // Method to handle selection logic.
   void toggleTimeSelection(String time) {
    if (selectedTimes.contains(time)) {
      // If the time is already selected, remove it.
      selectedTimes.remove(time);
    } else {
      // If the time is not selected, add it.
      selectedTimes.add(time);
    }
  }
  final RxString instructionText = ''.obs;
}
