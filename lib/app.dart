import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class PeronalWellNess extends StatelessWidget {
  const PeronalWellNess({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 847),
       minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,index){
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
            title: 'Personal Wellness',
        );
      },
    );
  }
}