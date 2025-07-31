import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],
        ),
        
        ),
        ),
    );
  }
}