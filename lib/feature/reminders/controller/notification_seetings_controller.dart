import 'package:get/get.dart';

class NotificationSeetingsController extends GetxController {
  // Switches
  final dailyReminder = true.obs; // matches screenshot: ON
  final routineReminder = true.obs;

  // Time selection - using booleans so UI can show checkboxes.
  final morning = false.obs;
  final evening = true.obs; // matches screenshot: Evening checked
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
      // if turned on and nothing selected, default to evening (like screenshot)
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
    // If morning or evening changed, recompute 'both'
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
      // turning off 'Both' clears morning/evening for clarity
      morning.value = false;
      evening.value = false;
    }
  }
}