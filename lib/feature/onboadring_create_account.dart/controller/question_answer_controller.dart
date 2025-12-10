import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/core/services/api_service.dart';
import 'package:personal_wellness/core/models/question_model.dart';

class QuestionAnswerController extends GetxController {
  // Loading state
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // Questions from API
  final RxList<QuestionData> questions = <QuestionData>[].obs;
  
  // Question 1: Gender
  final RxString selectedGender = ''.obs; // 'Male', 'Female', 'Non-binary'
  QuestionData? genderQuestion;
  
  // Question 2: User Type
  final RxString selectedUserType = ''.obs; // Selected user type
  final RxBool showOtherTextField = false.obs; // Show text field when "Other" is selected
  final TextEditingController otherUserTypeController = TextEditingController();
  final RxBool hasOtherUserTypeText = false.obs;
  QuestionData? userTypeQuestion;
  
  // Question 3: Why using the app
  final RxString selectedWhyUsingApp = ''.obs; // Selected reason
  QuestionData? whyUsingAppQuestion;
  
  // Get default options based on question text
  List<String> _getDefaultOptions(String questionText) {
    final lowerText = questionText.toLowerCase();
    
    if (lowerText.contains('gender')) {
      return ['Male', 'Female', 'Non-binary'];
    } else if (lowerText.contains('type') && lowerText.contains('user')) {
      return [
        'High-School Student',
        'College Student',
        'Graduate Student',
        'Busy Professional',
        'Busy Parent',
        'Other',
      ];
    } else if (lowerText.contains('why') || lowerText.contains('using')) {
      return [
        'To be more consistent with my skincare',
        'To stay more organized with my Skincare',
        'To help me better remember my SkinCare routine',
        'To get better result from my skinCare routine',
        'To get SkinCare suggestions from a professional app',
      ];
    }
    return [];
  }
  
  // Getter for user types from API or defaults
  List<String> get userTypes {
    if (userTypeQuestion != null) {
      if (userTypeQuestion!.options.isNotEmpty) {
        return userTypeQuestion!.options.map((opt) => opt.text).toList();
      }
      // Return default options if API doesn't provide them
      return _getDefaultOptions(userTypeQuestion!.question);
    }
    return [];
  }
  
  // Getter for why using app options from API or defaults
  List<String> get whyUsingAppOptions {
    if (whyUsingAppQuestion != null) {
      if (whyUsingAppQuestion!.options.isNotEmpty) {
        return whyUsingAppQuestion!.options.map((opt) => opt.text).toList();
      }
      // Return default options if API doesn't provide them
      return _getDefaultOptions(whyUsingAppQuestion!.question);
    }
    return [];
  }
  
  // Getter for gender options from API or defaults
  List<String> get genderOptions {
    if (genderQuestion != null) {
      if (genderQuestion!.options.isNotEmpty) {
        return genderQuestion!.options.map((opt) => opt.text).toList();
      }
      // Return default options if API doesn't provide them
      return _getDefaultOptions(genderQuestion!.question);
    }
    return [];
  }
  
  @override
  void onInit() {
    super.onInit();
    // Listen to other user type text changes
    otherUserTypeController.addListener(() {
      hasOtherUserTypeText.value = otherUserTypeController.text.isNotEmpty;
    });
    // Fetch questions from API
    fetchQuestions();
  }
  
  // Fetch questions from API
  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final questionModel = await ApiService.getAllQuestions();
      
      if (questionModel != null && questionModel.success) {
        questions.value = questionModel.data.result;
        
        // Sort questions by createdAt (or order if available)
        questions.sort((a, b) {
          if (a.createdAt != null && b.createdAt != null) {
            return a.createdAt!.compareTo(b.createdAt!);
          }
          return a.order.compareTo(b.order);
        });
        
        // Map questions to specific question types based on question text or order
        // You can customize this logic based on your API response structure
        for (var question in questions) {
          final questionText = question.question.toLowerCase();
          
          // Identify gender question
          if (questionText.contains('gender') || question.order == 1) {
            genderQuestion = question;
          }
          // Identify user type question
          else if (questionText.contains('type') && questionText.contains('user') || 
                   questionText.contains('user type') || question.order == 2) {
            userTypeQuestion = question;
          }
          // Identify why using app question
          else if (questionText.contains('why') || questionText.contains('using') || 
                   questionText.contains('app') || question.order == 3) {
            whyUsingAppQuestion = question;
          }
        }
        
        // If questions are not identified by text, use order-based assignment
        if (questions.isNotEmpty) {
          if (genderQuestion == null && questions.length > 0) {
            genderQuestion = questions[0];
          }
          if (userTypeQuestion == null && questions.length > 1) {
            userTypeQuestion = questions[1];
          }
          if (whyUsingAppQuestion == null && questions.length > 2) {
            whyUsingAppQuestion = questions[2];
          }
        }
        
        debugPrint('Questions loaded: ${questions.length}');
        debugPrint('Gender question: ${genderQuestion?.question}');
        debugPrint('User type question: ${userTypeQuestion?.question}');
        debugPrint('Why using app question: ${whyUsingAppQuestion?.question}');
      } else {
        errorMessage.value = questionModel?.message ?? 'Failed to load questions';
        debugPrint('Error loading questions: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching questions: $e';
      debugPrint('Exception loading questions: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Set gender
  void setGender(String gender) {
    selectedGender.value = gender;
  }
  
  // Set user type
  void setUserType(String userType) {
    selectedUserType.value = userType;
    // Check if the selected option is "Other" type
    bool isOther = false;
    if (userTypeQuestion != null && userTypeQuestion!.options.isNotEmpty) {
      final selectedOption = userTypeQuestion!.options.firstWhere(
        (opt) => opt.text == userType,
        orElse: () => QuestionOption(id: '', text: '', isOther: false),
      );
      isOther = selectedOption.isOther;
    } else {
      // Fallback to text-based check if options not available
      isOther = userType.toLowerCase() == 'other';
    }
    showOtherTextField.value = isOther;
    if (!showOtherTextField.value) {
      otherUserTypeController.clear();
    }
  }
  
  // Set why using app
  void setWhyUsingApp(String reason) {
    selectedWhyUsingApp.value = reason;
  }
  
  // Check if all required fields are filled
  bool get isFormValid {
    bool genderValid = genderQuestion == null || 
        (!genderQuestion!.isRequired || selectedGender.value.isNotEmpty);
    bool userTypeValid = userTypeQuestion == null || 
        (!userTypeQuestion!.isRequired || selectedUserType.value.isNotEmpty);
    bool otherTypeValid = !showOtherTextField.value || hasOtherUserTypeText.value;
    bool whyUsingAppValid = whyUsingAppQuestion == null || 
        (!whyUsingAppQuestion!.isRequired || selectedWhyUsingApp.value.isNotEmpty);
    
    return genderValid && userTypeValid && otherTypeValid && whyUsingAppValid;
  }
  
  // Submit form
  void submitAnswers() {
    if (isFormValid) {
      debugPrint('Gender: ${selectedGender.value}');
      debugPrint('User Type: ${selectedUserType.value}');
      if (selectedUserType.value == 'Other') {
        debugPrint('Other User Type: ${otherUserTypeController.text}');
      }
      debugPrint('Why using app: ${selectedWhyUsingApp.value}');
      
      // Navigate to BottomNavbar after submitting answers
      Get.to(() => BottomNavbar());
    }
  }
  
  // Clear all data
  void clearAll() {
    selectedGender.value = '';
    selectedUserType.value = '';
    showOtherTextField.value = false;
    otherUserTypeController.clear();
    selectedWhyUsingApp.value = '';
  }
  
  @override
  void onClose() {
    otherUserTypeController.dispose();
    super.onClose();
  }
}
