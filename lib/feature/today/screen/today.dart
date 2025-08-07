import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/colors.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:personal_wellness/feature/today/screen/routine_completed_view.dart';
import 'package:personal_wellness/feature/today/screen/routine_in_progressview.dart';
import 'package:personal_wellness/feature/today/screen/empty_routine_view.dart';

class Today extends StatelessWidget {
  Today({super.key});
  final TodayController controller = Get.put(TodayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        // Check if routineData is empty
        if (controller.routineData.isEmpty) {
          return const EmptyRoutineView();
        }

        bool allCompleted = controller.routineData.every((data) => data['isCompleted'].value == true);
        if (allCompleted) {
          return const RoutineCompletedView();
        }
        // If not empty and not all completed, show in-progress view
        return RoutineInProgressview();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
       
        },
        backgroundColor: const Color(0xff485908),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xffFFFFFF)),
      ),
    );
  }
}