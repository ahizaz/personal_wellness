import 'package:get/get.dart';

class SkinTypeController extends GetxController {
  final RxString selectedSkinType = ''.obs;

  void selectSkinType(String skinType) {
    selectedSkinType.value = skinType;
  }
}