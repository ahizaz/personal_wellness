import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/account_personalization.dart/controller/allargey_controller.dart';
import 'package:personal_wellness/feature/account_personalization.dart/screen/notifications_person.dart';
import 'package:personal_wellness/feature/account_personalization.dart/widget/allargey_option.dart';

class AllargeyLevel extends StatelessWidget {
  const AllargeyLevel({super.key});

  @override
  Widget build(BuildContext context) {
    final AllargeyController controller = Get.put(AllargeyController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.accountBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 33.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              IconPath.back,
                              height: 32.h,
                              width: 32.h,
                              fit: BoxFit.cover,
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
                      SizedBox(height: 28.h),
                      Text(
                        "What is your skin sensitivity\n                        level?",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 27.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff172601),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Obx(() => AllergyOption(
                            title: "Normal",
                            description: "I don't feel any allergy issue on my skin",
                            isSelected: controller.selectedAllergy.value == "Normal",
                            onTap: () => controller.selectAllergy("Normal"),
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => AllergyOption(
                            title: "Maybe, I have",
                            description: "Few times I feel etching on my face",
                            isSelected: controller.selectedAllergy.value == "Maybe, I have",
                            onTap: () => controller.selectAllergy("Maybe, I have"),
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => AllergyOption(
                            title: "Sensitive",
                            description: "Most often trouble with allergy",
                            isSelected: controller.selectedAllergy.value == "Sensitive",
                            onTap: () => controller.selectAllergy("Sensitive"),
                          )),
                      SizedBox(height: 16.h),
                      Obx(() => AllergyOption(
                            title: "Extreme",
                            description: "I’m having trouble with allergies always",
                            isSelected: controller.selectedAllergy.value == "Extreme",
                            onTap: () => controller.selectAllergy("Extreme"),
                          )),
                      SizedBox(height: 34.h),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => CustomButton(
                                  text: "Continue 4/5",
                                  color: Color(0xff172601),
                                  textStyle: TextStyle(
                                    fontFamily: "SFPro",
                                    color: controller.selectedAllergy.value.isEmpty
                                        ? Colors.grey // Faded when no selection
                                        : Color(0xffFFFFFF), // Clear when selected
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onTap: controller.selectedAllergy.value.isEmpty
                                      ? (){} // Disable when no selection
                                      : () {
                                          // Navigate to next page when selected
                                      Get.to(()=>NotificationsPerson()); // Replace with your route
                                        },
                                )),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomButton(
                              text: "Skip",
                              color: Color(0xffEDEEE6),
                              textStyle: TextStyle(
                                fontFamily: "SFPro",
                                color: Color(0xff172601),
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              onTap: () {
                                Get.to(() => NotificationsPerson());
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }
}