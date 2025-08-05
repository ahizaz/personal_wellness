import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AllargeyController extends GetxController {
  final RxString selectedAllergy = ''.obs;

  void selectAllergy(String allergy) {
    if (selectedAllergy.value == allergy) {
      selectedAllergy.value = ''; // Deselect if the same option is tapped again
    } else {
      selectedAllergy.value = allergy; // Select the new option
    }
  }
}
