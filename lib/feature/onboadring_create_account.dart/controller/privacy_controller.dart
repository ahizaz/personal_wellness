import 'package:get/get.dart';

class PrivacyController extends GetxController{
  var isTermsAgreed = false.obs;
  var isMarketingAgreed = false.obs;
  void toggleTermsAgreed(){
    isTermsAgreed.value = !isTermsAgreed.value;
  }
  void toggleMarketingAgreed(){
    isMarketingAgreed.value = !isMarketingAgreed.value;
  }
}