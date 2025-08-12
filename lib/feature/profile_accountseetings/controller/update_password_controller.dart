import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController{
     var obscureText = true.obs; 
   final TextEditingController passwordController= TextEditingController();
   var hasText = false.obs;
   

   @override
  void onInit() {
   
    super.onInit();
    passwordController.addListener((){
      hasText.value = passwordController.text.isNotEmpty;

    });
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value; // Toggle visibility
  }
@override
  void onClose() {
passwordController.dispose();
    super.onClose();
  }
  

}