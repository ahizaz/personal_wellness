import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:personal_wellness/core/services/notification_services.dart';
import 'package:personal_wellness/core/utils/constants/colors.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/controller/bottom_navcontroller.dart';
import 'package:personal_wellness/feature/explore/screen/add_to_routine.dart';
import 'package:personal_wellness/feature/explore/screen/explore.dart';
import 'package:personal_wellness/feature/notification/screen/notification_screen.dart';
import 'package:personal_wellness/feature/progress/screen/progress.dart';
import 'package:personal_wellness/feature/profile_accountseetings/screen/account.dart';
import 'package:personal_wellness/feature/today/controller/today_controller.dart';
import 'package:personal_wellness/feature/today/screen/routine_completed_view.dart';
import 'package:personal_wellness/feature/today/screen/routine_in_progressview.dart';
import 'package:personal_wellness/feature/today/screen/empty_routine_view.dart';

final RxBool isFabPressed = false.obs;

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> with WidgetsBindingObserver {
  final TodayController controller = Get.put(TodayController());
  final GlobalKey _fabKey = GlobalKey();
   final NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
       notificationServices.requestNotificationPermission();
       notificationServices.firebaseInit();
      // notificationServices.isTokenRefresh();
       notificationServices.getDeviceToken().then((value){
        print('devicetoken');
        print(value);

       });

  
     WidgetsBinding.instance.addPostFrameCallback((_) {
       notificationServices.initLocalNotifications(context);
     });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh routine data when app becomes active
      controller.refreshRoutineData();
    }
  }

  String _getGreetingMessage() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  void _showMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox fabBox = _fabKey.currentContext!.findRenderObject() as RenderBox;
    final Size fabSize = fabBox.size;
    final Offset fabTopRight = fabBox.localToGlobal(fabSize.topRight(Offset.zero), ancestor: overlay);

    const int itemCount = 4;
    const double itemHeight = 48.0;
    const double verticalPadding = 16.0;
    const double gapAboveFab = 12.0;
    final double estimatedMenuHeight = itemCount * itemHeight + verticalPadding;

    final double right = overlay.size.width - fabTopRight.dx;
    final double top = fabTopRight.dy - estimatedMenuHeight - gapAboveFab;
    final double left = fabTopRight.dx - 4;
    final double bottom = overlay.size.height - fabTopRight.dy;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      color: Colors.white,
      items: [
        PopupMenuItem(
          onTap: () {
            // Switch to Explore tab within BottomNavbar so the bottom bar stays visible
            Future.microtask(() {
              try {
                Get.find<BottomNavcontroller>().changeIndex(1);
              } catch (_) {
                // If controller isn't available for some reason, fall back to pushing Explore
                Get.to(() => Explore());
              }
            });
          },
          child: Row(
            children: const [
              Icon(Icons.add, color: Color(0xFF485908)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Product',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Color(0xff172601),
                    ),
                  ),
                  Text(
                    'Add new skincare product',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xff78816C),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            // Switch to Routine tab within BottomNavbar so the bottom bar stays visible
            Future.microtask(() {
              try {
                Get.find<BottomNavcontroller>().changeIndex(2);
              } catch (_) {
                // Fallback if controller isn't available
                Get.to(() => AddToRoutine());
              }
            });
          },
          child: Row(
            children: const [
              Icon(Icons.calendar_today_outlined, color: Color(0xFF485908)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log Routine',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Color(0xff172601),
                    ),
                  ),
                  Text(
                    'Record your routine',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xff78816C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            // Switch to Progress tab within BottomNavbar so the bottom bar stays visible
            Future.microtask(() {
              try {
                Get.find<BottomNavcontroller>().changeIndex(3);
              } catch (_) {
                // Fallback if controller isn't available
                Get.to(() => ProgressData());
              }
            });
          },
          child: Row(
            children: const [
              Icon(Icons.show_chart, color: Color(0xFF485908)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View Progress',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Color(0xff172601),
                    ),
                  ),
                  Text(
                    'Check your progress',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xff78816C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
           Get.to(()=>NotificationScreen());
          },
          child: Row(
            children: const [
              Icon(Icons.notifications_none_outlined, color: Color(0xFF5f6368)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminders',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Color(0xff172601),
                    ),
                  ),
                  Text(
                    'Manage notifications',
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xff78816C),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
       
      ],
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ).then((_) {
      // This is called when the menu is closed
      isFabPressed.value = false;
      // Refresh routine data in case user added new routine
      controller.refreshRoutineData();
    });
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => Account());
                },
                child: Obx(() {
                  final imagePath = controller.profileImagePath.value;
                  return CircleAvatar(
                    radius: 24.r,
                    backgroundImage: imagePath.isNotEmpty
                        ? FileImage(File(imagePath)) as ImageProvider
                        : AssetImage(IconPath.profileicon),
                  );
                }),
              ),
              SizedBox(width: 16.w),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi ${controller.userName.value}!",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3E4B2C),
                        ),
                      ),
                      Text(
                        _getGreetingMessage(),
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3E4B2C),
                        ),
                      ),
                    ],
                  )),
              const Spacer(),
              InkWell(
                onTap: (){
                  Get.to(()=>NotificationScreen());
                },
                child: Image.asset(IconPath.notificationhome,
                    height: 48.h, width: 48.w, fit: BoxFit.cover),
              ),
            
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          _buildProfileHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff485908),
                  ),
                );
              }
              if (controller.routineData.isEmpty) {
                return const EmptyRoutineView();
              }
              bool allCompleted = controller.routineData
                  .every((data) => data['isCompleted'].value == true);
              if (allCompleted) {
                return const RoutineCompletedView();
              }
              return RoutineInProgressview();
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          key: _fabKey,
          onPressed: () {
            isFabPressed.value = true;
            _showMenu(context);
          },
          backgroundColor: isFabPressed.value
              ? const Color(0xff172601)
              : const Color(0xff485908),
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: isFabPressed.value
                ? Colors.white.withValues(alpha: 0.5)
                : const Color(0xffFFFFFF),
          ),
        ),
      ),
    );
  }
}