import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AccountPersonlizationController extends GetxController{
  final TextEditingController displayNameController = TextEditingController();
  final RxBool isDisplayNameFocused = false.obs;
  final RxBool hasDisplayNameText = false.obs;
  @override
  void onInit() {
    
    super.onInit();
    displayNameController.addListener((){
      hasDisplayNameText.value=displayNameController.text.isNotEmpty;
    });
  }
  void clearDisplayName(){
    displayNameController.clear();
    hasDisplayNameText.value=false;
  }
  @override
  void onClose() {
    displayNameController.dispose();
    super.onClose();
  }
}