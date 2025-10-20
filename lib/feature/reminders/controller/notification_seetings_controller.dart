import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/feature/notification/controller/notification_controller.dart';
import 'package:personal_wellness/feature/notification/screen/notification_screen.dart';


class NotificationSeetingsController extends GetxController {
  // Switches
  final dailyReminder = true.obs; // default
  final routineReminder = true.obs;

  // Time selection - using booleans so UI can show checkboxes.
  final morning = false.obs;
  final evening = true.obs; // default true (as you had)
  final both = false.obs;

  // Computed property: Done button enabled only when both main toggles are ON
  bool get isDoneEnabled => dailyReminder.value && routineReminder.value;

  // Toggle daily reminder switch
  void toggleDailyReminder(bool value) {
    dailyReminder.value = value;
    if (!value) {
      // if daily reminders turned off, disable time selections
      morning.value = false;
      evening.value = false;
      both.value = false;
    } else {
      // if turned on and nothing selected, default to evening
      if (!morning.value && !evening.value && !both.value) {
        evening.value = true;
      }
    }
  }

  // Toggle routine completion reminder switch
  void toggleRoutineReminder(bool value) {
    routineReminder.value = value;
  }

  // Toggle Morning checkbox
  void toggleMorning(bool? value) {
    final v = value ?? false;
    morning.value = v;
    both.value = morning.value && evening.value;
  }

  // Toggle Evening checkbox
  void toggleEvening(bool? value) {
    final v = value ?? false;
    evening.value = v;
    both.value = morning.value && evening.value;
  }

  // Toggle Both: when set true -> set morning & evening true
  void toggleBoth(bool? value) {
    final v = value ?? false;
    both.value = v;
    if (v) {
      morning.value = true;
      evening.value = true;
    } else {
      morning.value = false;
      evening.value = false;
    }
  }

  // Called when user taps Done in the NotificationSeetings screen.
  // Shows EasyLoading spinner while updating notifications and navigates to NotificationScreen.
  Future<void> applySettingsAndShowNotifications(BuildContext context) async {
    // Decide what to include
    final includeMorning = morning.value || both.value;
    final includeEvening = evening.value || both.value;

    final notificationController = Get.put(NotificationController());

    try {
      EasyLoading.show(status: 'Loading...');
      // Save selected routine filters in the notification controller so future refresh merges accordingly
      notificationController.setRoutineFilters(
        includeMorning: includeMorning,
        includeEvening: includeEvening,
      );

      // Fetch push notifications and routines, merge and update the notifications list
      await notificationController.fetchNotifications();

      EasyLoading.showSuccess('Updated');
      // Navigate to NotificationScreen
      Get.to(() => NotificationScreen());
    } catch (e) {
      debugPrint('Error applying notification settings: $e');
      EasyLoading.showError('Failed to update');
    } finally {
      await Future.delayed(const Duration(milliseconds: 400));
      EasyLoading.dismiss();
    }
  }
}