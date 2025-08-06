import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/common/widgets/custom_button.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/controller/privacy_controller.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/otp_verification_default.dart';
class PrivacyPolicyTerms extends StatelessWidget {
  const PrivacyPolicyTerms({super.key});
  @override
  Widget build(BuildContext context) {
    final PrivacyController controller = Get.put(PrivacyController());
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
         mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Container(
            width: double.infinity,
           
            decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
                 borderRadius: BorderRadius.circular(32.r),
            ),
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   SizedBox(height: 33.h),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(IconPath.back),
                                  height: 32.h,
                                  width: 32.h,
                                  fit: BoxFit.cover,
                                ),
                              ],
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
                   SizedBox(height: 24.h,),
                   Center(
                    child: Image(image: AssetImage(ImagePath.privacypic,),width: 48.w,height: 48.h,fit: BoxFit.cover,),
                   ),
                   SizedBox(height: 16.h,),
                   Center(child: Text('Terms of service',style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff172601)
                   ),),),
                   SizedBox(height: 24.h,),
                   Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Color(0xffE8E9E6),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r)
                        )
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 16.h),
                        child: Row(
                          children: [
                            Expanded(child: RichText(text: TextSpan(
                            style:  TextStyle(
                               fontFamily: "SFPro",
                               fontSize: 17.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff000000),
                            ),
                            children: [
                               TextSpan(text: 'I agree with SKINspired '),
                                  TextSpan(
                        text: 'Terms of\nservice ',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: "SFPro",
                               fontSize: 17.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff000000),

                        )
                      ),
                        const TextSpan(text: ' & '),
                          TextSpan(
                        text: 'Privacy Policy',
                        style:  TextStyle(
                       decoration: TextDecoration.underline,
                          fontFamily: "SFPro",
                           fontSize:  17.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff000000),
                        ),
                      ),
               
                            ]  
                            ))),
                            const SizedBox(width: 8),
                             Obx(()=>Checkbox(value: controller.isTermsAgreed.value, onChanged:(value){
                                 controller.toggleTermsAgreed();
                             },
                             side: BorderSide(
                                      color: Color(0xff172601), // বর্ডার কালার পরিবর্তন
                                      width: 2,
                                    ),
                                    activeColor: Color(0xff172601), // চেক হলে কালার
                             
                             
                             ))
                          ],
                        ),
                      ),
                         Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Color(0xffE8E9E6),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r)
                        )
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 16.h),
                        child: Row(
                          children: [
                           Expanded(child: Text("Agree to receive marketing\nupdates from SKINSpired",style: TextStyle(
                              fontFamily: "SFPro",
                               fontSize: 17.sp,
                               fontWeight: FontWeight.w400,
                               color: Color(0xff000000),
                           ),)),
                             Obx(()=>Checkbox(value: controller.isMarketingAgreed.value, onChanged: (value){
                              controller.toggleMarketingAgreed();
                             },
                             side: BorderSide(
                              color: Color(0xff172601), // বর্ডার কালার পরিবর্তন
                                      width: 2,
                             ),
                             activeColor: Color(0xff172601),
                             ))
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h,),
                               Obx(
                            () => CustomButton(
                              text: "Continue",
                              color: Color(0xff172601), // ব্যাকগ্রাউন্ড কালার অপরিবর্তিত
                              textStyle: TextStyle(
                                fontFamily: 'SFPro',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffffff).withOpacity(
                                    controller.isTermsAgreed.value ? 1.0 : 0.5),
                              ),
                              onTap:controller.isTermsAgreed.value?(){
                                   Get.to(()=>OtpVerificationDefault());
                              }:(){}
                        
                            ),
                          ),
                      SizedBox(height: 24.h,),
                    ],
                   )
                   
                ],
            ),
            
            ),
          ) ,
          SizedBox(height: 33.h,) 
          ],
        ),
        
        ),
       ),
    );
  }
}