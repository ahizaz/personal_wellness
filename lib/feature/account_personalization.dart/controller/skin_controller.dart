import 'package:get/get.dart';

class SkinTypeController extends GetxController {
  final RxString selectedSkinType = ''.obs;

  void selectSkinType(String skinType) {
    if (selectedSkinType.value == skinType) {
      selectedSkinType.value = ''; // Deselect if the same skin type is clicked again
    } else {
      selectedSkinType.value = skinType; // Select the new skin type
    }
 // Debug print to verify selection
  }
}