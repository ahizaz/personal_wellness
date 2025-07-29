import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/splash_screen/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
   final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(ImagePath.splashScreenPic,fit: BoxFit.cover,),
      ),
    );
  }
}