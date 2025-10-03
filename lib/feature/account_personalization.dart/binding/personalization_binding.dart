import 'package:get/get.dart';
import 'package:personal_wellness/feature/account_personalization.dart/controller/personalization_controller.dart';

class PersonalizationBinding extends Bindings {
  @override
  void dependencies() {
    // Create a single instance that will be shared across all screens
    Get.put<PersonalizationController>(PersonalizationController(), permanent: true);
  }
}