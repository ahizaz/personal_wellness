import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/utils/theme/theme.dart';
import 'package:personal_wellness/feature/splash_screen/screen/splash_screen.dart';
import 'package:personal_wellness/core/events/routine_events.dart';
import 'package:personal_wellness/feature/account_personalization.dart/controller/personalization_controller.dart';

class PeronalWellNess extends StatelessWidget {
  const PeronalWellNess({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize global event bus
    Get.put(RoutineEvents());
    
    // Initialize global PersonalizationController
    Get.put(PersonalizationController(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(402, 874), // Portrait design size
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Wellness',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
} 