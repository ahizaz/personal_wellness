
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/explore/controller/routine_controller.dart';
import 'package:personal_wellness/feature/explore/widget/category_bottom_sheet.dart';
import 'package:personal_wellness/feature/explore/widget/category_icon.dart';
import 'package:personal_wellness/feature/explore/widget/date_picker_helper.dart';
import 'package:personal_wellness/feature/explore/widget/progress_dialog.dart';
import 'package:personal_wellness/feature/explore/widget/time_picker_bottom_sheet.dart';
class AddToRoutine extends StatelessWidget {
  AddToRoutine({super.key});
  final RoutineController controller = Get.put(RoutineController());
  final GlobalKey startKey = GlobalKey();
  final GlobalKey endKey = GlobalKey();

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CategoryBottomSheet();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add to my routine',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff172601),
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        IconPath.cross,
                        width: 32.w,
                        height: 32.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 26.h),
                const Text(
                  "Product Type",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    _showCategoryBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Text(
                        "Choose Category",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff172601),
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        IconPath.rightarrow,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  if (controller.selectedCategory.value.isNotEmpty) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryIcon(category: controller.selectedCategory.value),
                          SizedBox(width: 8.w),
                          Text(
                            controller.selectedCategory.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                SizedBox(height: 24.h),
                Text(
                  "Schedule",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    DatePickerHelper.showDateBottomSheet(
                      context: context,
                      isStart: true,
                      key: startKey,
                      controller: controller,
                    );
                  },
                  child: Obx(
                    () => Container(
                      key: startKey,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: controller.startFocused.value
                              ? const Color(0xff172601)
                              : Colors.grey[300]!,
                          width: controller.startFocused.value ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage(IconPath.calendar),
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.startDate.value == null
                                ? 'Start date'
                                : DateFormat('dd/MM/yy').format(controller.startDate.value!),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: controller.startDate.value == null
                                  ? Colors.grey
                                  : const Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    DatePickerHelper.showDateBottomSheet(
                      context: context,
                      isStart: false,
                      key: endKey,
                      controller: controller,
                    );
                  },
                  child: Obx(
                    () => Container(
                      key: endKey,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: controller.endFocused.value
                              ? const Color(0xff172601)
                              : Colors.grey[300]!,
                          width: controller.endFocused.value ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage(IconPath.calendar),
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.endDate.value == null
                                ? 'End date'
                                : DateFormat('dd/MM/yy').format(controller.endDate.value!),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: controller.endDate.value == null
                                  ? Colors.grey
                                  : const Color(0xff172601),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Order",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(() => SizedBox(
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 2.5,
                        children: List.generate(9, (index) {
                          int number = index + 1;
                          return GestureDetector(
                            onTap: () {
                              if (controller.selectedOrder.value == number) {
                                controller.selectedOrder.value = 0; // Unselect
                              } else {
                                controller.selectedOrder.value = number; // Select
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedOrder.value == number
                                    ? const Color(0xff485908)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Center(
                                child: Text(
                                  '$number',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w400,
                                    color: controller.selectedOrder.value == number
                                        ? Colors.white
                                        : const Color(0xff3E4B2C),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )),
                SizedBox(height: 27.h),
                Row(
                  children: [
                    Text(
                      "Time of day",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff172601),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const TimePickerBottomSheet(),
                        );
                      },
                      child: Image.asset(
                        IconPath.rightarrow,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 23.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: controller.availableTimes.length,
                  itemBuilder: (context, index) {
                    final time = controller.availableTimes[index];
                    return Obx(() {
                      final isSelected = controller.selectedTimes.contains(time);
                      return GestureDetector(
                        onTap: () {
                          controller.toggleTimeSelection(time);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xff485908) : Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xff485908)
                                  : const Color(0xffE0E0E0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              time,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                color: isSelected ? Colors.white : const Color(0xff3E4B2C),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 24.h),
                Text(
                  "Additional instruction",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Container(
                    height: 102.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: controller.instructionText.value.isEmpty
                            ? const Color(0xffE0E0E0)
                            : const Color(0xff485908),
                        width: 2.w,
                      ),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        controller.instructionText.value = text;
                      },
                      decoration: InputDecoration(
                        hintText: "Add Instruction",
                        hintStyle: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff757575),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      ),
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff172601),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Cancel",
                        textStyle: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          color: Color(0xff172601),
                        ),
                        color: Color(0xffEDEEE6),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(() {
                      final enabled = controller.isFormValid;
                      return Expanded(
                        child: CustomButton(
                          text: "Submit",
                          color: enabled
                              ? const Color(0xff172601)
                              : const Color(0xffA0A09F), // dim color if disabled
                          onTap: !enabled
                              ? () {}:(){
                               ProgressDialog.show(context, controller); // Replace _showProgressDialog with this
                             controller.submitRoutine();
                                }
                              // Disable button tap if not enabled
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 26.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}