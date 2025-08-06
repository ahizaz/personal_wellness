import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/colors.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:personal_wellness/feature/today/screen/empty_routine_view.dart';


class Today extends StatelessWidget {
 Today({super.key});
  final TodayController controller = Get.put(TodayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: EmptyRoutineView(),
    );
  }
}