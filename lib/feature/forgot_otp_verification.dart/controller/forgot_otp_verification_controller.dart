import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:personal_wellness/core/urls/urls.dart';

class ForgotOtpVerification extends GetxController{
  final forgotEmailController  = TextEditingController();
  final isForgotEmailFocused = false.obs;
  final hasForgotEmailText = false.obs;
  @override
  void onInit() {
    super.onInit();
    forgotEmailController.addListener((){
    hasForgotEmailText.value = forgotEmailController.text.isNotEmpty;
    });
  }

void clearForgotEmail(){
  forgotEmailController.clear();
  hasForgotEmailText.value = false;
}
Future<bool>sendForgotPasswordEmail()async{
  final email = forgotEmailController.text.trim();
  if(email.isEmpty)return false;
  EasyLoading.show(status: 'Sending...');
  final url = Urls.forgetpassword;
  try{
    final response = await http.post(
      Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),

      
    );
    EasyLoading.dismiss();
    if(response.statusCode==200){
      return true;
    }else{
      EasyLoading.showError("Failed: ${response.body}");
      return false;

    }
  }catch(e){
       EasyLoading.dismiss();
      EasyLoading.showError("Network Error");
      return false;
  }
}

  @override
  void onClose() {
   forgotEmailController.dispose();
    super.onClose();
  }
}