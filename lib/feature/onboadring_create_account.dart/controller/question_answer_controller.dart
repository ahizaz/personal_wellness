import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/core/common/widgets/health_disclaimer_dialog.dart';
import 'dart:convert';

class QuestionAnswerController extends GetxController {
  // Loading state
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool disclaimerShown = false.obs;
  
  // Questions from API - storing raw question data
  final RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;
  
  // Question 1: Gender
  final RxString selectedGender = ''.obs; // 'Male', 'Female', 'Non-binary'
  Map<String, dynamic>? genderQuestion;
  
  // Question 2: User Type (allow multiple selections)
  final RxList<String> selectedUserTypes = <String>[].obs; // Selected user types
  final RxBool showOtherTextField = false.obs; // Show text field when "Other" is selected among selections
  final TextEditingController otherUserTypeController = TextEditingController();
  final RxBool hasOtherUserTypeText = false.obs;
  Map<String, dynamic>? userTypeQuestion;
  
  // Question 3: Why using the app (allow multiple selections)
  final RxList<String> selectedWhyUsingApp = <String>[].obs; // Selected reasons
  Map<String, dynamic>? whyUsingAppQuestion;
  
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
        'Busy Professionalssssssssssssssssss',
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

  // Normalize various option payload shapes from API into List<String>
  List<String> _normalizeOptions(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map<String>((e) {
        if (e == null) return '';
        if (e is String) return e;
        if (e is Map) {
          return (e['label'] ?? e['value'] ?? e['option'] ?? e['ans'] ?? e['text'] ?? e.toString()).toString();
        }
        return e.toString();
      }).where((s) => s.isNotEmpty).toList();
    }
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        return _normalizeOptions(decoded);
      } catch (_) {
        return [raw];
      }
    }
    return [];
  }
  
  // Getter for user types from API or defaults
  List<String> get userTypes {
    if (userTypeQuestion != null) {
      final opts = userTypeQuestion!['options'] as List<String>?;
      if (opts != null && opts.isNotEmpty) return opts;
      return _getDefaultOptions(userTypeQuestion!['question'] ?? '');
    }
    return [];
  }
  
  // Getter for why using app options from API or defaults
  List<String> get whyUsingAppOptions {
    if (whyUsingAppQuestion != null) {
      final opts = whyUsingAppQuestion!['options'] as List<String>?;
      if (opts != null && opts.isNotEmpty) return opts;
      return _getDefaultOptions(whyUsingAppQuestion!['question'] ?? '');
    }
    return [];
  }
  
  // Getter for gender options from API or defaults
  List<String> get genderOptions {
    if (genderQuestion != null) {
      final opts = genderQuestion!['options'] as List<String>?;
      if (opts != null && opts.isNotEmpty) return opts;
      return _getDefaultOptions(genderQuestion!['question'] ?? '');
    }
    return [];
  }
  
  @override
  void onInit() {
    super.onInit();
    debugPrint('=== QuestionAnswerController onInit ===');
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
      debugPrint('=== Starting to fetch questions ===');
      isLoading.value = true;
      errorMessage.value = '';
      
      EasyLoading.show(
        status: 'Loading questions...',
        maskType: EasyLoadingMaskType.black,
      );

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('ERROR: No access token found');
        errorMessage.value = 'Please login again';
        EasyLoading.showError("Please login again");
        return;
      }

      debugPrint('=== Making API call to get questions ===');
      debugPrint('URL: ${Urls.getAllQuestion}');
      debugPrint('Access Token: ${accessToken.substring(0, accessToken.length > 20 ? 20 : accessToken.length)}...');

      final response = await http.get(
        Uri.parse(Urls.getAllQuestion),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      debugPrint('=== API Response received ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('=== Parsing response data ===');
        debugPrint('Success: ${data["success"]}');
        debugPrint('Message: ${data["message"]}');

        if (data["success"] == true && data["data"] != null && data["data"]["result"] != null) {
          questions.clear();
          
          // Extract questions from the result array
          final resultList = data["data"]["result"] as List;
          debugPrint('=== Found ${resultList.length} questions ===');
          
          for (var questionItem in resultList) {
            // Try to read option lists from common keys that APIs might use
            final dynamic rawOptions = questionItem['options'] ?? questionItem['option'] ?? questionItem['choices'] ?? questionItem['optionsList'] ?? questionItem['answers'];
            final List<String> normalizedOptions = _normalizeOptions(rawOptions);

            final questionMap = {
              "_id": questionItem["_id"] ?? "",
              "question": questionItem["question"] ?? "",
              "isVisible": questionItem["isVisible"] ?? true,
              "createdAt": questionItem["createdAt"] ?? "",
              "updatedAt": questionItem["updatedAt"] ?? "",
              // store normalized options (may be empty)
              "options": normalizedOptions,
            };
            questions.add(questionMap);
            debugPrint('Question: ${questionMap["question"]} (ID: ${questionMap["_id"]}) Options: ${normalizedOptions.length}');
          }
          
          // Map questions to specific question types based on question text
          for (var question in questions) {
            final questionText = (question['question'] ?? '').toString().toLowerCase();
            
            // Identify gender question
            if (questionText.contains('gender')) {
              genderQuestion = question;
              debugPrint('Found Gender Question: ${question['question']}');
            }
            // Identify user type question
            else if (questionText.contains('type') && questionText.contains('user')) {
              userTypeQuestion = question;
              debugPrint('Found User Type Question: ${question['question']}');
            }
            // Identify why using app question
            else if (questionText.contains('why') || (questionText.contains('using') && questionText.contains('app'))) {
              whyUsingAppQuestion = question;
              debugPrint('Found Why Using App Question: ${question['question']}');
            }
          }
          
          // If questions are not identified by text, use order-based assignment
          if (questions.isNotEmpty) {
            if (genderQuestion == null && questions.length > 0) {
              genderQuestion = questions[0];
              debugPrint('Assigned first question as Gender: ${questions[0]['question']}');
            }
            if (userTypeQuestion == null && questions.length > 1) {
              userTypeQuestion = questions[1];
              debugPrint('Assigned second question as User Type: ${questions[1]['question']}');
            }
            if (whyUsingAppQuestion == null && questions.length > 2) {
              whyUsingAppQuestion = questions[2];
              debugPrint('Assigned third question as Why Using App: ${questions[2]['question']}');
            }
          }
          
          debugPrint('=== Questions loaded successfully ===');
          debugPrint('Total questions: ${questions.length}');
          debugPrint('Gender question: ${genderQuestion?['question']}');
          debugPrint('User type question: ${userTypeQuestion?['question']}');
          debugPrint('Why using app question: ${whyUsingAppQuestion?['question']}');
          
          EasyLoading.showSuccess("Questions loaded successfully");
          
          // Show health disclaimer after questions are loaded
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!disclaimerShown.value) {
              showHealthDisclaimer();
            }
          });
        } else {
          errorMessage.value = data["message"] ?? 'Failed to load questions';
          debugPrint('ERROR: Failed to load questions: ${errorMessage.value}');
          EasyLoading.showError("Failed to load questions");
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
        debugPrint('ERROR: Server error: ${response.statusCode}');
        EasyLoading.showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = 'Error fetching questions: $e';
      debugPrint('EXCEPTION: Error loading questions: $e');
      EasyLoading.showError("Error loading questions");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
      debugPrint('=== Finished fetching questions ===');
    }
  }
  
  // Set gender
  void setGender(String gender) {
    debugPrint('=== Setting Gender: $gender ===');
    selectedGender.value = gender;
  }
  
  void toggleUserType(String userType) {
    debugPrint('=== Toggling User Type: $userType ===');
    if (selectedUserTypes.contains(userType)) {
      selectedUserTypes.remove(userType);
    } else {
      selectedUserTypes.add(userType);
    }
    // Show other text field if any selected option is "Other"
    bool isOther = selectedUserTypes.any((e) => e.toLowerCase() == 'other');
    showOtherTextField.value = isOther;
    if (!showOtherTextField.value) {
      otherUserTypeController.clear();
    }
    debugPrint('Show Other Text Field: $isOther');
  }
  
  // Toggle why using app option
  void toggleWhyUsingApp(String reason) {
    debugPrint('=== Toggling Why Using App: $reason ===');
    if (selectedWhyUsingApp.contains(reason)) {
      selectedWhyUsingApp.remove(reason);
    } else {
      selectedWhyUsingApp.add(reason);
    }
  }
  
  // Check if all required fields are filled
  bool get isFormValid {
    bool genderValid = genderQuestion == null || selectedGender.value.isNotEmpty;
    bool userTypeValid = userTypeQuestion == null || selectedUserTypes.isNotEmpty;
    bool otherTypeValid = !showOtherTextField.value || hasOtherUserTypeText.value;
    bool whyUsingAppValid = whyUsingAppQuestion == null || selectedWhyUsingApp.isNotEmpty;
    
    final isValid = genderValid && userTypeValid && otherTypeValid && whyUsingAppValid;
    debugPrint('=== Form Validation ===');
    debugPrint('Gender Valid: $genderValid');
    debugPrint('User Type Valid: $userTypeValid');
    debugPrint('Other Type Valid: $otherTypeValid');
    debugPrint('Why Using App Valid: $whyUsingAppValid');
    debugPrint('Form Valid: $isValid');
    
    return isValid;
  }
  
  // Submit form
  Future<void> submitAnswers() async {
    if (!isFormValid) {
      debugPrint('ERROR: Form is not valid, cannot submit');
      EasyLoading.showError('Please fill all required fields');
      return;
    }

    try {
      debugPrint('=== Starting to submit answers ===');
      
      EasyLoading.show(
        status: 'Submitting answers...',
        maskType: EasyLoadingMaskType.black,
      );

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('ERROR: No access token found');
        EasyLoading.showError("Please login again");
        return;
      }

      // Prepare answers array
      List<Map<String, String>> answersList = [];

      // Add gender answer
      if (genderQuestion != null && selectedGender.value.isNotEmpty) {
        answersList.add({
          "questionId": genderQuestion!['_id'] ?? '',
          "ans": selectedGender.value,
        });
        debugPrint('Added Gender Answer: ${genderQuestion!['_id']} -> ${selectedGender.value}');
      }

      // Add user type answer (join multiple selections with comma)
      if (userTypeQuestion != null && selectedUserTypes.isNotEmpty) {
        String answerText;
        if (showOtherTextField.value && otherUserTypeController.text.isNotEmpty) {
          answerText = otherUserTypeController.text;
        } else {
          answerText = selectedUserTypes.join(', ');
        }
        answersList.add({
          "questionId": userTypeQuestion!['_id'] ?? '',
          "ans": answerText,
        });
        debugPrint('Added User Type Answer: ${userTypeQuestion!['_id']} -> $answerText');
      }

      // Add why using app answer (join multiple selections with comma)
      if (whyUsingAppQuestion != null && selectedWhyUsingApp.isNotEmpty) {
        String whyAns = selectedWhyUsingApp.join(', ');
        answersList.add({
          "questionId": whyUsingAppQuestion!['_id'] ?? '',
          "ans": whyAns,
        });
        debugPrint('Added Why Using App Answer: ${whyUsingAppQuestion!['_id']} -> $whyAns');
      }

      debugPrint('=== Total answers to submit: ${answersList.length} ===');
      debugPrint('Answers JSON: ${jsonEncode(answersList)}');

      final response = await http.post(
        Uri.parse(Urls.answer),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(answersList),
      );

      debugPrint('=== Submit Answers API Response ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('=== Success Response ===');
        debugPrint('Response Data: $data');

        if (data["success"] == true) {
          // Mark questions as answered in SharedPreferences
          await prefs.setBool('hasAnsweredQuestions', true);
          debugPrint('=== Questions answered successfully ===');
          debugPrint('Saved hasAnsweredQuestions flag to SharedPreferences');
          
          EasyLoading.showSuccess('Answers submitted successfully!');
          
          // Navigate to BottomNavbar after submitting answers
          await Future.delayed(Duration(milliseconds: 500));
          Get.offAll(() => BottomNavbar());
        } else {
          debugPrint('ERROR: API returned success=false: ${data["message"]}');
          EasyLoading.showError(data["message"] ?? "Failed to submit answers");
        }
      } else {
        debugPrint('ERROR: Server error: ${response.statusCode}');
        EasyLoading.showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('EXCEPTION: Error submitting answers: $e');
      EasyLoading.showError("Error submitting answers");
    } finally {
      EasyLoading.dismiss();
      debugPrint('=== Finished submitting answers ===');
    }
  }
  
  // Clear all data
  void clearAll() {
    selectedGender.value = '';
    selectedUserTypes.clear();
    showOtherTextField.value = false;
    otherUserTypeController.clear();
    selectedWhyUsingApp.clear();
  }
  
  // Show health disclaimer dialog
  void showHealthDisclaimer() {
    if (Get.context != null && !disclaimerShown.value) {
      disclaimerShown.value = true;
      HealthDisclaimerDialog.show(
        Get.context!,
        () {
          debugPrint('Health disclaimer accepted');
        },
      );
    }
  }
  
  @override
  void onClose() {
    otherUserTypeController.dispose();
    super.onClose();
  }
}
