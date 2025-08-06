import 'package:get/get.dart';
import 'package:personal_wellness/feature/today/widget/routine_step.dart';

class TodayController extends GetxController {
  var routineSteps = <RoutineStep>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data dekhate chaile ei line use korbe
    loadDummyData();

 
  }

  void loadDummyData() {
    routineSteps.value = [
      RoutineStep(name: "Cleanser", isCompleted: true),
      RoutineStep(name: "Serum", isCompleted: true),
      RoutineStep(name: "Sun's Cream", isCompleted: true),
    ];
  }

  bool isAllStepsCompleted() {
    return routineSteps.isNotEmpty &&
        routineSteps.every((step) => step.isCompleted);
  }
}