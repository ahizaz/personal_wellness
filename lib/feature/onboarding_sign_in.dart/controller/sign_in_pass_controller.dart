import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignInPassController extends GetxController{
   var obscureText = true.obs; 
   final TextEditingController signInPasswordController = TextEditingController();
   var hasText = false.obs;

   @override
  void onInit() {
   
    super.onInit();
    signInPasswordController.addListener((){
      hasText.value = signInPasswordController.text.isNotEmpty;

    });
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value; // Toggle visibility
  }
@override
  void onClose() {
   signInPasswordController.dispose();
    super.onClose();
  }


}