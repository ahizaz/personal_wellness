import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:personal_wellness/core/utils/theme/theme.dart';
import 'package:personal_wellness/feature/splash_screen/screen/splash_screen.dart';

class PeronalWellNess extends StatelessWidget {
  const PeronalWellNess({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait only
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

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