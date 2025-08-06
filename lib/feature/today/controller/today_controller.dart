import 'package:get/get.dart';

class TodayController extends GetxController {
  var userName = "Liana".obs; // default text "Hi there!"
  var profileImagePath = "".obs; 
  var isCleanserCompleted = false.obs;
  // default no image

  void setUserName(String name) {
    userName.value = name;
  }

  void setProfileImage(String path) {
    profileImagePath.value = path;
  }
  void toggleCleanserCompletion(bool value) {
    isCleanserCompleted.value = value;
  }
}
