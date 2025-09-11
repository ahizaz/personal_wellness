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

  /// ✅ Google Sign-In + Backend
  /// ✅ Google Sign-In + Backend (with debug prints)
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      print("🚀 Starting Google Sign-In...");

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile', 'openid'],
        serverClientId: '954043915554-5a819pb2s1g5jdci52j89lnh49e8p2l7.apps.googleusercontent.com',
      );

      try {
        await googleSignIn.signOut();
        print("🔄 Previous Google session signed out");
      } catch (e) {
        print("⚠️ Error signing out previous session: $e");
      }

      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        isLoading.value = false;
        print("❌ Google sign-in cancelled by user");
        Get.snackbar('Cancelled', 'Google sign-in cancelled');
        return;
      }

      print("✅ Google account selected: ${account.email}");

      final GoogleSignInAuthentication googleAuth = await account.authentication;
      print("🔑 AccessToken: ${googleAuth.accessToken}");
      print("🔑 IdToken: ${googleAuth.idToken}");

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      print("👤 Firebase User: ${user?.uid}, Email: ${user?.email}");

      final String id = user?.uid ?? account.id;
      final String email = user?.email ?? account.email;
      final String name = user?.displayName ?? account.displayName ?? '';
      final String photo = user?.photoURL ?? account.photoUrl ?? '';

      final Map<String, dynamic> body = {
        "email": email,
        "firstName": name,
        "image": photo,
        "uid": "google_$id",
      };

      print("📦 Sending data to backend: $body");

      final response = await http.post(
        Uri.parse(Urls.googlesignin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("🌍 Backend Response: ${response.statusCode}");
      print("📨 Response Body: ${response.body}");

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Google Sign-In successful, navigating to BottomNavbar");
        Get.offAll(() => BottomNavbar());
      } else {
        print("❌ Backend login failed");
        Get.snackbar('Error', 'Failed to login with Google');
      }
    } on PlatformException catch (e) {
      isLoading.value = false;
      print("⚠️ PlatformException: ${e.message}");
      Get.snackbar('Error', e.message ?? 'Google sign-in failed');
    } catch (e) {
      isLoading.value = false;
      print("🔥 Exception: $e");
      Get.snackbar('Error', 'Something went wrong');
    }
  }

}
