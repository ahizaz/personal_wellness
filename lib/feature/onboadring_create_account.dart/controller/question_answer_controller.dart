import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';

class QuestionAnswerController extends GetxController {
  // Questions list (will be populated from API)
  final RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;
  
  // Text controllers for text input questions
  final TextEditingController whyUsingAppController = TextEditingController();
  
  // Additional question controllers
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  
  // Age verification (18+)
  final RxString ageVerification = ''.obs; // 'yes' or 'no'
  
  // Track if fields have text
  final RxBool hasWhyUsingAppText = false.obs;
  final RxBool hasQuestion1Text = false.obs;
  final RxBool hasQuestion2Text = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Listen to text changes
    whyUsingAppController.addListener(() {
      hasWhyUsingAppText.value = whyUsingAppController.text.isNotEmpty;
    });
    question1Controller.addListener(() {
      hasQuestion1Text.value = question1Controller.text.isNotEmpty;
    });
    question2Controller.addListener(() {
      hasQuestion2Text.value = question2Controller.text.isNotEmpty;
    });
  }
  
  // Check if all required fields are filled
  bool get isFormValid {
    return hasWhyUsingAppText.value &&
           ageVerification.value.isNotEmpty &&
           hasQuestion1Text.value &&
           hasQuestion2Text.value;
  }
  
  // Set age verification
  void setAgeVerification(String value) {
    ageVerification.value = value;
  }
  
  // Submit form
  void submitAnswers() {
    if (isFormValid) {
     
      print('Why using app: ${whyUsingAppController.text}');
      print('Age 18+: ${ageVerification.value}');
      print('Question 1: ${question1Controller.text}');
      print('Question 2: ${question2Controller.text}');
      
      // Navigate to BottomNavbar after submitting answers
      Get.to(() => BottomNavbar());
    }
  }
  
  // Method to load questions from API (to be implemented when API is ready)
  Future<void> loadQuestions() async {

  }
  
  // Clear all data
  void clearAll() {
    whyUsingAppController.clear();
    question1Controller.clear();
    question2Controller.clear();
    ageVerification.value = '';
  }
  
  @override
  void onClose() {
    whyUsingAppController.dispose();
    question1Controller.dispose();
    question2Controller.dispose();
    super.onClose();
  }
}
