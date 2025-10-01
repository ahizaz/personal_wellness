import 'package:get/get.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';

class BottomNavcontroller extends GetxController{
  final RxInt selectedIndex = 0.obs;
  
  void changeIndex(int index) async {
    selectedIndex.value = index;
    
    // If user navigates to Today tab (index 0), refresh Today controller
    if (index == 0) {
      try {
        final todayController = Get.find<TodayController>();
        print('User navigated to Today tab - refreshing routine data');
        await todayController.refreshRoutineData();
      } catch (e) {
        print('Today controller not found or error refreshing: $e');
        // This is normal if Today controller hasn't been initialized yet
      }
    }
  }
  
}