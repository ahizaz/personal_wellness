import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoutineEvents extends GetxController {
  // Observable for routine updates
  var routineAdded = false.obs;
  var lastRoutineAddedTime = DateTime.now().obs;
  
  // Method to notify that a new routine was added
  void notifyRoutineAdded() {
    lastRoutineAddedTime.value = DateTime.now();
    routineAdded.value = !routineAdded.value; // Toggle to trigger observers
    debugPrint('=== Routine Added Event Triggered ===');
  }
  
  // Get singleton instance
  static RoutineEvents get instance => Get.find<RoutineEvents>();
}