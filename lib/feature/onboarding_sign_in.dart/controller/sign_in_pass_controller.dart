import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_wellness/core/services/notification_services.dart';
import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/question_answer.dart';

class SignInPassController extends GetxController {
  var obscureText = true.obs;
  final TextEditingController signInPasswordController = TextEditingController();
  var hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    signInPasswordController.addListener(() {
      hasText.value = signInPasswordController.text.isNotEmpty;
    });
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<bool> login(String email, String password) async {
    const String apiUrl = '${Urls.baseUrl}/auth/login';
    try {
      await EasyLoading.show(
        status: 'Logging in...',
        maskType: EasyLoadingMaskType.black,
      );

      // Fetch current FCM token before login
      final NotificationServices notificationServices = NotificationServices();
      String? fcmToken;
      try {
        fcmToken = await notificationServices.getDeviceToken();
      } catch (e) {
        fcmToken = null; // proceed without token if retrieval fails
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          if (fcmToken != null) 'fcmToken': fcmToken,
        }),
      );

      await EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          String accessToken = responseData['data']['accessToken'];
          String userId = responseData['data']['user']['_id'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('userId', userId);
          
          debugPrint('=== Login successful ===');
          debugPrint('Checking if questions have been answered...');
          
          // Check if questions have been answered
          final hasAnsweredQuestions = prefs.getBool('hasAnsweredQuestions') ?? false;
          debugPrint('hasAnsweredQuestions: $hasAnsweredQuestions');
          
          EasyLoading.showSuccess('Login successful!');
          
          if (hasAnsweredQuestions) {
            debugPrint('Questions already answered, navigating to BottomNavbar');
            Get.offAll(() => BottomNavbar());
          } else {
            debugPrint('Questions not answered yet, navigating to QuestionAnswer');
            Get.offAll(() => const QuestionAnswer());
          }
          return true;
        } else {
          EasyLoading.showError('Invalid response from server');
          return false;
        }
      } else {
        EasyLoading.showError('Invalid email or password');
        return false;
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong. Please try again.');
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  void onClose() {
    signInPasswordController.dispose();
    super.onClose();
  }
}