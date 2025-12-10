import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/sign_in_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:personal_wellness/core/urls/urls.dart';
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';
import 'package:personal_wellness/core/services/notification_services.dart';
import 'package:personal_wellness/feature/onboadring_create_account.dart/screen/question_answer.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final registerController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  final isRegisterEmailFocused = false.obs;
  final isEmailFocused = false.obs;

  final hasText = false.obs;
  final hasRegisterText = false.obs;
  final hasNameText = false.obs;
  final hasAgeText = false.obs;
  final selectedGender = ''.obs;

  var email = ''.obs;
  var name = ''.obs;
  var age = ''.obs;
  var gender = ''.obs;

  final isLoading = false.obs;

  // Computed property to check if all personal info is filled
  RxBool get hasAllPersonalInfo =>
      (hasNameText.value && hasAgeText.value && selectedGender.value.isNotEmpty)
          .obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      hasText.value = emailController.text.isNotEmpty;
      email.value = emailController.text;
    });
    registerController.addListener(() {
      hasRegisterText.value = registerController.text.isNotEmpty;
      email.value = registerController.text;
    });
    nameController.addListener(() {
      hasNameText.value = nameController.text.isNotEmpty;
      name.value = nameController.text;
    });
    ageController.addListener(() {
      hasAgeText.value = ageController.text.isNotEmpty;
      age.value = ageController.text;
    });
  }

  void clearEmail() {
    emailController.clear();
    hasText.value = false;
    registerController.clear();
    hasRegisterText.value = false;
  }

  void clearPersonalInfo() {
    nameController.clear();
    hasNameText.value = false;
    ageController.clear();
    hasAgeText.value = false;
    selectedGender.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    registerController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.onClose();
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Signing in...');

      try {
        await _googleSignIn.signOut();
      } catch (_) {}
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Get current FCM token to send with Google login
      String? fcmToken;
      try {
        fcmToken = await NotificationServices().getDeviceToken();
      } catch (_) {}

      final body = {
        "email": googleUser.email,
        "firstName": googleUser.displayName ?? "",
        "image":
            googleUser.photoUrl ??
            "https://static.vecteezy.com/system/resources/previews/005/005/788/non_2x/user-icon-in-trendy-flat-style-isolated-on-grey-background-user-symbol-for-your-web-site-design-logo-app-ui-illustration-eps10-free-vector.jpg",
        "uid": "google_${googleUser.id}",
        if (fcmToken != null) "fcmToken": fcmToken,
      };

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/google-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          final accessToken = data["data"]["accessToken"];
          final userData = data["data"]["user"] ?? {};
          final userId = userData["_id"] ?? userData["id"];
          final firstName =
              userData["firstName"] ??
              googleUser.displayName?.split(' ').first ??
              "";

          final prefs = await SharedPreferences.getInstance();
          if (accessToken is String) {
            await prefs.setString("accessToken", accessToken);
          }
          if (userId is String) {
            await prefs.setString("userId", userId);
          }
          // Save firstName for display in app
          if (firstName.isNotEmpty) {
            await prefs.setString("personalization_firstName", firstName);
            // Also cache a quick local fallback and set Firebase displayName
            await prefs.setString('user_name', firstName);
            try {
              final firebaseUser = FirebaseAuth.instance.currentUser;
              if (firebaseUser != null) {
                await firebaseUser.updateDisplayName(firstName);
              }
            } catch (e) {
              debugPrint('Error updating Firebase displayName: $e');
            }
            debugPrint("Saved Google firstName: $firstName");
          }

          debugPrint('=== Google Sign In successful ===');
          debugPrint('Checking if questions have been answered...');
          
          // Check if questions have been answered
          final hasAnsweredQuestions = prefs.getBool('hasAnsweredQuestions') ?? false;
          debugPrint('hasAnsweredQuestions: $hasAnsweredQuestions');
          
          if (hasAnsweredQuestions) {
            debugPrint('Questions already answered, navigating to BottomNavbar');
            Get.offAll(() => BottomNavbar());
          } else {
            debugPrint('Questions not answered yet, navigating to QuestionAnswer');
            Get.offAll(() => const QuestionAnswer());
          }
        } else {
          debugPrint("Backend error: ${data["message"]}");
        }
      } else {
        debugPrint("Server error: ${response.statusCode}");
      }
    } on PlatformException catch (e) {
      debugPrint('PlatformException code: ${e.code}');
      debugPrint('PlatformException message: ${e.message ?? ''}');
      debugPrint('PlatformException details: ${e.details?.toString() ?? ''}');
    } catch (e) {
      debugPrint('Generic sign-in error: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("userId");
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    Get.offAll(() => const SignInForm());
  }
}
