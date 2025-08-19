import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/sign_in_form.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImagePath.gettingStarted),fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            Spacer(),
            Padding(padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: CustomButton(text: "Get Started ", color: Color(0xff0E1701), onTap: (){
              Get.to(()=> SignInForm (),transition: Transition.noTransition);
              
            })
            
            ),
            SizedBox(height: 40.h,),
          ],
        ),
      ),
      
    );
  }
}