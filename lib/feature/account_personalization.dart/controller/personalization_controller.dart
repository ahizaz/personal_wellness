import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/services/personalization_service.dart';

class PersonalizationController extends GetxController {
  // Form controllers (matching old controller property names)
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  
  // Observable variables (matching old controller property names)
  final RxBool isDisplayNameFocused = false.obs;
  final RxBool hasDisplayNameText = false.obs;
  final RxBool isLastNameFocused = false.obs;
  final RxBool hasLastNameText = false.obs;
  
  // Personalization data
  final RxString selectedDateOfBirth = ''.obs;
  final RxString selectedSkinType = ''.obs;
  final RxString selectedAllergyLevel = ''.obs;
  
  // Computed properties
  RxBool get isFormValid => (hasDisplayNameText.value && hasLastNameText.value).obs;

  @override
  void onInit() {
    super.onInit();
    displayNameController.addListener(() {
      hasDisplayNameText.value = displayNameController.text.isNotEmpty;
    });
    lastNameController.addListener(() {
      hasLastNameText.value = lastNameController.text.isNotEmpty;
    });
  }

  // Set date of birth
  void setDateOfBirth(String date) {
    selectedDateOfBirth.value = date;
  }

  // Set skin type
  void setSkinType(String skinType) {
    if (selectedSkinType.value == skinType) {
      selectedSkinType.value = ''; // Deselect if same type clicked
    } else {
      selectedSkinType.value = skinType;
    }
  }

  // Set allergy level
  void setAllergyLevel(String allergyLevel) {
    if (selectedAllergyLevel.value == allergyLevel) {
      selectedAllergyLevel.value = ''; // Deselect if same level clicked
    } else {
      selectedAllergyLevel.value = allergyLevel;
    }
  }

  // Convert skin type to API format
  String _getSkinLevelForAPI() {
    switch (selectedSkinType.value) {
      case 'Oily':
        return 'oily';
      case 'Dry':
        return 'dry';
      case 'Normal':
        return 'medium';
      case 'Combination':
        return 'combination';
      case 'Sensitive':
        return 'sensitive';
      default:
        return 'medium';
    }
  }

  // Convert allergy level to type for API
  String _getTypeForAPI() {
    switch (selectedAllergyLevel.value) {
      case 'Normal':
        return 'normal';
      case 'Maybe, I have':
        return 'maybe';
      case 'Sensitive':
        return 'sensitive';
      case 'Extreme':
        return 'extreme';
      default:
        return 'personal'; // fallback to personal if no allergy level selected
    }
  }

  // Validate all required data
  bool _validateData() {
    debugPrint('=== VALIDATION CHECK ===');
    debugPrint('First Name: "${displayNameController.text.trim()}" (Empty: ${displayNameController.text.trim().isEmpty})');
    debugPrint('Last Name: "${lastNameController.text.trim()}" (Empty: ${lastNameController.text.trim().isEmpty})');
    debugPrint('Date of Birth: "${selectedDateOfBirth.value}" (Empty: ${selectedDateOfBirth.value.isEmpty})');
    debugPrint('Skin Type: "${selectedSkinType.value}" (Empty: ${selectedSkinType.value.isEmpty})');
    debugPrint('Allergy Level: "${selectedAllergyLevel.value}" (Empty: ${selectedAllergyLevel.value.isEmpty})');
    
    final isValid = displayNameController.text.trim().isNotEmpty &&
           lastNameController.text.trim().isNotEmpty &&
           selectedDateOfBirth.value.isNotEmpty &&
           selectedSkinType.value.isNotEmpty;
    
    debugPrint('Overall Validation Result: $isValid');
    debugPrint('========================');
    
    return isValid;
  }

  // Submit personalization data
  Future<bool> submitPersonalization() async {
    debugPrint('=== SUBMIT PERSONALIZATION CALLED ===');
    debugPrint('Controller instance: ${this.hashCode}');
    
    if (!_validateData()) {
      debugPrint('=== VALIDATION FAILED ===');
      EasyLoading.showError('Please fill in all required information');
      return false;
    }

    // Test network connection first
    debugPrint('=== TESTING NETWORK CONNECTION ===');
    final connectionOk = await PersonalizationService.testConnection();
    if (!connectionOk) {
      debugPrint('=== NETWORK CONNECTION FAILED ===');
      EasyLoading.showError('Network connection failed. Please check your internet connection.');
      return false;
    }

    debugPrint('=== STARTING PERSONALIZATION SUBMISSION ===');
    debugPrint('First Name: ${displayNameController.text.trim()}');
    debugPrint('Last Name: ${lastNameController.text.trim()}');
    debugPrint('Date of Birth: ${selectedDateOfBirth.value}');
    debugPrint('Selected Skin Type: ${selectedSkinType.value}');
    debugPrint('Selected Allergy Level: ${selectedAllergyLevel.value}');
    debugPrint('API Type: ${_getTypeForAPI()}');
    debugPrint('API Skin Level: ${_getSkinLevelForAPI()}');
    debugPrint('===============================================');

    EasyLoading.show(status: 'Creating personalization...');
    
    try {
      final success = await PersonalizationService.createPersonalization(
        firstName: displayNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        dateOfBirth: selectedDateOfBirth.value,
        type: _getTypeForAPI(),
        skinLevel: _getSkinLevelForAPI(),
      );

      debugPrint('=== PERSONALIZATION API RESULT ===');
      debugPrint('Success: $success');
      debugPrint('==================================');

      if (success) {
        EasyLoading.showSuccess('Personalization completed successfully!');
        return true;
      } else {
        EasyLoading.showError('Failed to save personalization. Please try again.');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Print all collected data for debugging
  void printAllData() {
    debugPrint('=== PERSONALIZATION CONTROLLER DATA ===');
    debugPrint('Controller Instance: ${this.hashCode}');
    debugPrint('First Name: "${displayNameController.text.trim()}"');
    debugPrint('Last Name: "${lastNameController.text.trim()}"');
    debugPrint('Date of Birth: "${selectedDateOfBirth.value}"');
    debugPrint('Skin Type: "${selectedSkinType.value}"');
    debugPrint('Allergy Level: "${selectedAllergyLevel.value}"');
    debugPrint('API Type (from allergy): "${_getTypeForAPI()}"');
    debugPrint('API Skin Level: "${_getSkinLevelForAPI()}"');
    debugPrint('======================================');
  }

  // Test method to check if token exists
  Future<void> checkToken() async {
    debugPrint('=== TOKEN CHECK FROM CONTROLLER ===');
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userId = prefs.getString('userId');
      final allKeys = prefs.getKeys();
      
      debugPrint('Access Token: ${accessToken != null ? "${accessToken.substring(0, accessToken.length < 20 ? accessToken.length : 20)}..." : "NULL"}');
      debugPrint('Token Length: ${accessToken?.length ?? 0}');
      debugPrint('User ID: $userId');
      debugPrint('All SharedPreferences Keys: $allKeys');
      debugPrint('=================================');
    } catch (e) {
      debugPrint('Error checking token: $e');
    }
  }

  // Debug method to check current controller state
  void debugCurrentState() {
    debugPrint('=== CONTROLLER CURRENT STATE ===');
    debugPrint('Controller Hash: ${this.hashCode}');
    debugPrint('First Name: "${displayNameController.text}"');
    debugPrint('Last Name: "${lastNameController.text}"');
    debugPrint('Date of Birth: "${selectedDateOfBirth.value}"');
    debugPrint('Skin Type: "${selectedSkinType.value}"');
    debugPrint('Allergy Level: "${selectedAllergyLevel.value}"');
    debugPrint('===============================');
  }

  // Clear all data
  void clearAllData() {
    displayNameController.clear();
    lastNameController.clear();
    selectedDateOfBirth.value = '';
    selectedSkinType.value = '';
    selectedAllergyLevel.value = '';
    hasDisplayNameText.value = false;
    hasLastNameText.value = false;
  }

  @override
  void onClose() {
    displayNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}