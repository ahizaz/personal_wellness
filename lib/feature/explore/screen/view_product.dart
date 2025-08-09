import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_wellness/feature/today/widget/product_header.dart';

class ViewProduct extends StatelessWidget {
  const ViewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xffEDEEE6),
       body:SafeArea(child: SingleChildScrollView(
        child: Padding(padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  ProductHeader(title: 'Product',),
              ],
        ),
        ),
       )),

    );
  }
}