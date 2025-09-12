// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:personal_wellness/core/urls/urls.dart';
 // Urls class import
import 'package:personal_wellness/feature/bottom_navBar.dart/screen/bottom_navbar.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final registerController = TextEditingController();

  final isRegisterEmailFocused = false.obs;
  final isEmailFocused = false.obs;

  final hasText = false.obs;
  final hasRegisterText = false.obs;
  var email = ''.obs;

  final isLoading = false.obs;
  
  // Google Sign-In instance (Firebase only, no web client ID)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
  }

  void clearEmail() {
    emailController.clear();
    hasText.value = false;
    registerController.clear();
    hasRegisterText.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    registerController.dispose();
    super.onClose();
  }
Future<void> signInWithGoogle() async {
  try {
    isLoading.value = true;

    print('Starting Google sign-in...');
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print('Result account: ' + (googleUser?.email ?? 'null'));
    if (googleUser == null) {
      print('User cancelled Google sign-in');
      isLoading.value = false;
      return; // user cancelled
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print('Got tokens. idToken: ' + (googleAuth.idToken != null).toString());

    // Sign in to Firebase with Google credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;
    print('Firebase user: ' + (user?.uid ?? 'null'));

    // Prepare minimal payload for backend
    final body = {
      "email": googleUser.email,
      "firstName": googleUser.displayName ?? "",
      "image": googleUser.photoUrl ??
          "https://static.vecteezy.com/system/resources/previews/005/005/788/non_2x/user-icon-in-trendy-flat-style-isolated-on-grey-background-user-symbol-for-your-web-site-design-logo-app-ui-illustration-eps10-free-vector.jpg",
      "uid": "google_${googleUser.id}",
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
        final refreshToken = data["data"]["refreshToken"];

        /// 🔥 Debug print tokens
        print("Access Token: $accessToken");
        print("Refresh Token: $refreshToken");

        // ✅ Save tokens in local storage
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString("accessToken", accessToken);
        // await prefs.setString("refreshToken", refreshToken);

        // Navigate to BottomNavBar
        Get.offAll(() => BottomNavbar());

        Get.snackbar("Success", "User login successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print("Backend error: ${data["message"]}");
        Get.snackbar("Error", data["message"] ?? "Login failed");
      }
    } else {
      print("Server error: ${response.statusCode}");
      Get.snackbar("Error", "Server error: ${response.statusCode}");
    }
  } on PlatformException catch (e) {
    print('PlatformException code: ' + (e.code.toString()));
    print('PlatformException message: ' + (e.message ?? ''));
    print('PlatformException details: ' + (e.details?.toString() ?? ''));
    Get.snackbar('Error', '${e.code}: ${e.message ?? 'Google sign-in failed'}');
  } catch (e) {
    print('Generic sign-in error: ' + e.toString());
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}

 

}
