import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';

class TodayController extends GetxController {
  var userName = "Liana".obs; // Default username
  var profileImagePath = "".obs; // Default no image
  var routineData = <Map<String, dynamic>>[].obs; // Reactive list for routine data

  @override
  void onInit() {
    super.onInit();
    // Initialize routineData with placeholder data (to be replaced by API)
    routineData.assignAll([
      {
        'icon': IconPath.cleanser,
        'title': 'Cleanser',
        'description': 'Basic Hydrating Facial Cleanser',
        'time': '6:30 AM',
        'isCompleted': RxBool(false), // Reactive boolean
      },
      {
        'icon': IconPath.night, // Ensure this exists in IconPath
        'title': 'Night Cream',
        'description': 'CeraVe Skin Renewing Night Cream',
        'time': '6:45 AM',
        'isCompleted': RxBool(false),
      },
      {
        'icon': IconPath.sun, // Ensure this exists in IconPath
        'title': 'Sunscreen',
        'description': 'Banana Boat Sport Ultra SPF 50\n Sunscreen Lotion',
        'time': '7:00 AM',
        'isCompleted': RxBool(false),
      },
    ]);
  }

  void setUserName(String name) {
    userName.value = name;
  }

  void setProfileImage(String path) {
    profileImagePath.value = path;
  }

  void toggleCompletion(int index, bool value) {
    if (index >= 0 && index < routineData.length) {
      routineData[index]['isCompleted'].value = value;
    }
  }
}