import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AccountPersonlizationController extends GetxController{
  final TextEditingController displayNameController = TextEditingController();
  final RxBool isDisplayNameFocused = false.obs;
  final RxBool hasDisplayNameText = false.obs;

  final TextEditingController lastNameController = TextEditingController();
  final RxBool isLastNameFocused = false.obs;
  final RxBool hasLastNameText = false.obs;
  RxBool get isFormValid => (hasDisplayNameText.value && hasLastNameText.value).obs;

  @override
  void onInit() {
    
    super.onInit();
    displayNameController.addListener((){
      hasDisplayNameText.value=displayNameController.text.isNotEmpty;
    });
    lastNameController.addListener((){
         hasLastNameText.value = lastNameController.text.isNotEmpty;
    });
  }
  void clearAllData() {
    clearDisplayName();
    clearLastName();
  }
  void clearDisplayName(){
    displayNameController.clear();
    hasDisplayNameText.value=false;

  }
  void clearLastName() {
    lastNameController.clear();
    hasLastNameText.value = false;
  }
  @override
  void onClose() {
    displayNameController.dispose();
     lastNameController.dispose();
    super.onClose();
  }
}