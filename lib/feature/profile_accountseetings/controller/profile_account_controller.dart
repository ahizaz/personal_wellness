import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileAccountController extends GetxController {
  var selectedMonth = ''.obs;
  // First Name Controller এবং স্টেট
  final TextEditingController firstNameController = TextEditingController();
  final RxBool isFirstNameFocused = false.obs;
  final RxBool hasFirstNameText = false.obs;

  // Last Name Controller এবং স্টেট
  final TextEditingController lastNameController = TextEditingController();
  final RxBool isLastNameFocused = false.obs;
  final RxBool hasLastNameText = false.obs;

  // ফর্ম ভ্যালিডেশন (দুটি ফিল্ডেই টেক্সট থাকতে হবে)
  RxBool get isFormValid => (hasFirstNameText.value && hasLastNameText.value).obs;

  @override
  void onInit() {
    super.onInit();

    // প্রথম নামের টেক্সট লিসেনার
    firstNameController.addListener(() {
      hasFirstNameText.value = firstNameController.text.isNotEmpty;
    });

    // শেষ নামের টেক্সট লিসেনার
    lastNameController.addListener(() {
      hasLastNameText.value = lastNameController.text.isNotEmpty;
    });
  }

  // সব ডাটা ক্লিয়ার করার মেথড
  void clearAllData() {
    clearFirstName();
    clearLastName();
  }

  void clearFirstName() {
    firstNameController.clear();
    hasFirstNameText.value = false;
  }

  void clearLastName() {
    lastNameController.clear();
    hasLastNameText.value = false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
