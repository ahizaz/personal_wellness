// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/profile_accountseetings/screen/account_seetings.dart';
import 'package:personal_wellness/feature/profile_accountseetings/screen/inventory.dart';
import 'package:personal_wellness/feature/profile_accountseetings/screen/logout.dart';
import 'package:personal_wellness/feature/profile_accountseetings/screen/update_password.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'dart:io';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final TodayController controller = Get.find<TodayController>();

    return Scaffold(
      backgroundColor: Color(0xffEDEEE6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                   Image(image: AssetImage(ImagePath.apptitle),width: 201.w,height: 40.h,fit: BoxFit.cover,),
                   Spacer(),
                   Image(image: AssetImage(IconPath.notification),width: 24.w,height: 30.h,fit: BoxFit.cover,),
                   SizedBox(width: 16.w),
                   Image(image: AssetImage(IconPath.seetings),width: 24.w,height: 30.h,fit: BoxFit.cover,)
                  ],
                ),
                SizedBox(height: 28.h,),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        final imagePath = controller.profileImagePath.value;
                        return CircleAvatar(
                          radius: 60.r,
                          backgroundImage: imagePath.isNotEmpty
                              ? FileImage(File(imagePath)) as ImageProvider
                              : AssetImage(IconPath.profileicon),
                        );
                      }),
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            controller.setProfileImage(pickedFile.path);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: EdgeInsets.all(8.w),
                          child: Icon(Icons.camera_alt, size: 24.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
               SizedBox(height: 15.h,),
               Center(
                child: Text("LANA YOLO",style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 28.sp,
                  color: Color(0xff000000),
                ),),
               ),
               SizedBox(height: 48.h,),
               Container(
                width: double.infinity,
           
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Color(0xffFFFFFF),
                  
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h,),
                      Row(
                        children: [
                         Image(image: AssetImage(IconPath.account),width: 24.w,height: 24.h,fit: BoxFit.cover,),
                         SizedBox(width: 16.w,),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Account settings",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),),
                            SizedBox(height: 4.h,),
                            Text("Update your personal details",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3E4B2C)
                            ),)

                          ],
                         ),
                         Spacer(),
                      InkWell(
  onTap: () {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return const AccountSeetings();
      },
    );
  },
  child: Image(
    image: AssetImage(IconPath.profilearrow),
    width: 24.w,
    height: 24.h,
    fit: BoxFit.cover,
  ),
)
                        ],
                      ),
                      SizedBox(height: 16.h,),
                        Row(
                        children: [
                         InkWell(child: Image(image: AssetImage(IconPath.securityseetings),width: 24.w,height: 24.h,fit: BoxFit.cover,)),
                         SizedBox(width: 16.w,),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Security settings",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),),
                            SizedBox(height: 4.h,),
                            Text("Update your mail & password",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3E4B2C)
                            ),)

                          ],
                         ),
                         Spacer(),
                         InkWell(onTap:(){
                            showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return UpdatePassword();
      },
    );

                         },child: InkWell(child: Image(image: AssetImage(IconPath.profilearrow),width: 24.w,height: 24.h,fit: BoxFit.cover,)))
                        ],
                      ),
                      SizedBox(height: 16.h,),
                        Row(
                        children: [
                         Image(image: AssetImage(IconPath.profilestatus),width: 24.w,height: 24.h,fit: BoxFit.cover,),
                         SizedBox(width: 16.w,),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Profile status",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),),
                            SizedBox(height: 4.h,),
                            Text("Your profile is 72% completed",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3E4B2C)
                            ),)

                          ],
                         ),
                         Spacer(),
                         InkWell(child: Image(image: AssetImage(IconPath.profilearrow),width: 24.w,height: 24.h,fit: BoxFit.cover,))
                        ],
                      ),
                      SizedBox(height: 16.h,),
                        Row(
                        children: [
                         Image(image: AssetImage(IconPath.notification),width: 24.w,height: 24.h,fit: BoxFit.cover,),
                         SizedBox(width: 16.w,),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Notification settings",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),),
                            SizedBox(height: 4.h,),
                            Text("Set notification reminders",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3E4B2C)
                            ),)

                          ],
                         ),
                         Spacer(),
                         InkWell(child: Image(image: AssetImage(IconPath.profilearrow),width: 24.w,height: 24.h,fit: BoxFit.cover,))
                        ],
                      ),
                        SizedBox(height: 16.h,),
                        Row(
                        children: [
                         Image(image: AssetImage(IconPath.inventory),width: 24.w,height: 24.h,fit: BoxFit.cover,),
                         SizedBox(width: 16.w,),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Inventory",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),),
                            SizedBox(height: 4.h,),
                            Text("Discover skin care products",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3E4B2C)
                            ),)

                          ],
                         ),
                         Spacer(),
                         InkWell(onTap:(){
                          Get.to(()=>Inventory());
                         },child: InkWell(child: Image(image: AssetImage(IconPath.profilearrow),width: 24.w,height: 24.h,fit: BoxFit.cover,)))
                        ],
                      ),
                        SizedBox(height: 16.h,),
                        Row(
                        children: [
                         Image(image: AssetImage(IconPath.logout),width: 24.w,height: 24.h,fit: BoxFit.cover,),
                         SizedBox(width: 16.w,),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Log out",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)
                            ),),
                            SizedBox(height: 4.h,),
                            Text("lorem ipsum",style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff3E4B2C)
                            ),)

                          ],
                         ),
                         Spacer(),
                         InkWell(onTap:(){
                         showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        return Logout();
      },
    );
                         },child: InkWell(child: Image(image: AssetImage(IconPath.profilearrow),width: 24.w,height: 24.h,fit: BoxFit.cover,)))
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      
                    ],
                  ),
                ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}