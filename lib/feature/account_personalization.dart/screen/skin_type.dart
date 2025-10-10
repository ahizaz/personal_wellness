
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/account_personalization.dart/controller/personalization_controller.dart';
import 'package:personal_wellness/feature/account_personalization.dart/screen/allargey_level.dart';

class SkinType extends StatelessWidget {
  const SkinType({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.find<PersonalizationController>();

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
                      Center(
                        child: Text(
                          "Select your skin type",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff172601),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h,),
                  
                      Obx(() => GridView.count(
                         padding: EdgeInsets.zero, 
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 1.w,
                            mainAxisSpacing: 10.h,
                            children: [
                              _buildSkinTypeCard(context, 'Normal', controller),
                              _buildSkinTypeCard(context, 'Dry', controller),
                              _buildSkinTypeCard(context, 'Oily', controller),
                              _buildSkinTypeCard(context, 'Combination', controller),
                            ],
                          )),
                          SizedBox(height: 34.h,),
                          Row(
                            children: [
                                     Expanded(
                            child: Obx(() => CustomButton(
                                  text: "Continue 3/5",
                                  color: Color(0xff172601),
                                  textStyle: TextStyle(
                                    fontFamily: "SFPro",
                                    color: controller.selectedSkinType.value.isEmpty
                                        ? Colors.grey // Faded color when no selection
                                        : Color(0xffFFFFFF), // Original white text when selected
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onTap: controller.selectedSkinType.value.isEmpty
                                      ? (){} // Disable button when no selection
                                      : () {
                                          debugPrint('=== SKIN TYPE CONTINUE PRESSED ===');
                                          controller.debugCurrentState();
                                          // Navigate to next page when selected
                                         Get.to(()=>AllargeyLevel()); // Replace with your route
                                        },
                                )),
                          ),
                              SizedBox(width: 12.w,),
                                  Expanded(child: CustomButton(text: "Skip", color: Color(0xffEDEEE6),textStyle: TextStyle(
                                    fontFamily: "SFPro",
                                    color: Color(0xff172601),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600
                                  ), onTap: (){
                                    Get.to(()=>AllargeyLevel());

                              })),
                              
                         
                            ],
                          ),
                          SizedBox(height: 24.h,)

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
Widget _buildSkinTypeCard(BuildContext context, String skinType, PersonalizationController controller) {
  final isSelected = controller.selectedSkinType.value == skinType;
  return GestureDetector(
    onTap: () {
      controller.setSkinType(skinType);
      debugPrint('=== SKIN TYPE SELECTED ===');
      debugPrint('Selected Skin Type: $skinType');
      debugPrint('Controller Hash: ${controller.hashCode}');
      debugPrint('=========================');
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 155.w,
              height: 138.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: isSelected ? Border.all(color: Color(0xff485908), width: 3.0) : null,
               
              ),
              child: Image.asset(
                _getSkinImagePath(skinType),
                fit: BoxFit.cover,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(Icons.check_circle, color: Color(0xff485908), size: 20.sp),
              ),
          ],
        ),
    
        Text(
          skinType,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
         fontFamily:  'SFPro',
            color: Color(0xff3E4B2C)
          ),
        ),
      ],
    ),
  );
}


  String _getSkinImagePath(String skinType) {
    switch (skinType.toLowerCase()) {
      case 'normal':
        return ImagePath.normalface;
      case 'dry':
        return ImagePath.dryface;
      case 'oily':
        return ImagePath.oilyface;
      case 'combination':
        return ImagePath.combenationface;
      default:
        return '';
    }
  }
}
