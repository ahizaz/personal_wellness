import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/constants/colors.dart';
import 'package:personal_wellness/feature/explore/screen/add_to_routine.dart';
import 'package:personal_wellness/feature/explore/screen/explore.dart';
import 'package:personal_wellness/feature/progress/screen/progress.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:personal_wellness/feature/today/screen/routine_completed_view.dart';
import 'package:personal_wellness/feature/today/screen/routine_in_progressview.dart';
import 'package:personal_wellness/feature/today/screen/empty_routine_view.dart';

class Today extends StatelessWidget {
  Today({super.key});
  final TodayController controller = Get.put(TodayController());
  final GlobalKey _fabKey = GlobalKey();

  // This function now builds the UI you want
  void _showMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox fabBox = _fabKey.currentContext!.findRenderObject() as RenderBox;
    final Size fabSize = fabBox.size;
    final Offset fabTopRight = fabBox.localToGlobal(fabSize.topRight(Offset.zero), ancestor: overlay);

    // Estimate menu height so its bottom stays a bit above the FAB
    const int itemCount = 4; // current number of menu items
    const double itemHeight = 48.0;
    const double verticalPadding = 16.0; // menu padding/margins
    const double gapAboveFab = 12.0; // desired gap above FAB
    final double estimatedMenuHeight = itemCount * itemHeight + verticalPadding;

    // Position so the menu ends at the FAB's top-right, with a gap above the FAB
    final double right = overlay.size.width - fabTopRight.dx;
    final double top = fabTopRight.dy - estimatedMenuHeight - gapAboveFab;
    final double left = fabTopRight.dx - 4; // slight left bias to end at FAB edge
    final double bottom = overlay.size.height - fabTopRight.dy;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      color: Colors.white,
      items: [
        // Helper function to create each menu item
        PopupMenuItem(
          onTap: () {
           Get.off(()=>Explore());
          },
          child: Row(
            children: const [
              Icon(Icons.add, color: Color(0xFF485908)), // Dark grey icon
              SizedBox(width: 8), // Spacing
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                'Add Product',
                style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xff172601)
                ),
              ),
               Text(
                'Add new skincare product',
                style: TextStyle(
                       fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xff78816C)
                ),
              ),
                ],
               )
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
        Get.off(()=>AddToRoutine());
          },
          child: Row(
            children: const [
              Icon(Icons.calendar_today_outlined, color: Color(0xFF485908)),
              SizedBox(width: 8),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                'Log Routine',
                style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xff172601)
                ),
              ),
               Text(
                'Record your routine',
                style: TextStyle(
                       fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xff78816C)
                ),
              ),
             
                ],
               ),
            ],
          ),
        ),
        
        PopupMenuItem(
          onTap: () {
           Get.off(()=>ProgressData());
          },
          child: Row(
            children: const [
              Icon(Icons.show_chart, color: Color(0xFF485908)),
              SizedBox(width: 8),
         Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                'View Progress',
                style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xff172601)
                ),
              ),
               Text(
                'Check your progress',
                style: TextStyle(
                       fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xff78816C)
                ),
              ),
          
                ],
               ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            // Your logic for managing reminders
          },
          child: Row(
            children: const [
              Icon(Icons.notifications_none_outlined, color: Color(0xFF5f6368)),
              SizedBox(width: 8),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                'Reminders',
                style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xff172601)
                ),
              ),
               Text(
                'Manage notifications',
                style: TextStyle(
                       fontFamily: "SFPro",
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xff78816C)
                ),
              ),
              ],
             )
            ],
          ),
        ),
      ],
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.routineData.isEmpty) {
          return const EmptyRoutineView();
        }
        bool allCompleted =
            controller.routineData.every((data) => data['isCompleted'].value == true);
        if (allCompleted) {
          return const RoutineCompletedView();
        }
        return RoutineInProgressview();
      }),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () => _showMenu(context),
        backgroundColor: const Color(0xff485908),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xffFFFFFF)),
      ),
    );
  }
}