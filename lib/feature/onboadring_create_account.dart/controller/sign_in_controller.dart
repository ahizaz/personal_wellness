// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:personal_wellness/core/urls/urls.dart';
 // Urls class import

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
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Use only google_sign_in (no Firebase). Optionally set serverClientId if you want reliable idToken.
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile', 'openid'],
        // serverClientId: 'YOUR_SERVER_CLIENT_ID.apps.googleusercontent.com', // optional but recommended
      );

      // Clear any stale session to avoid silent failures
      try { await googleSignIn.signOut(); } catch (_) {}

      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        // User cancelled
        isLoading.value = false;
        Get.snackbar('Cancelled', 'Google sign-in cancelled');
        return;
      }

      // Obtain tokens (idToken/accessToken may be null if serverClientId isn't configured)
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      final String? accessToken = auth.accessToken;

      final id = account.id;
      final email = account.email;
      final name = account.displayName ?? '';
      final photo = account.photoUrl ?? '';

      // Backend request body
      final body = {
        "email": email,
        "firstName": name,
        "image": photo,
        "uid": "google_$id",
        "provider": "google",
        // Send tokens if available; backend can verify Google identity
        "idToken": idToken,
        "accessToken": accessToken,
      };

      final response = await http.post(
        Uri.parse(Urls.googlesignin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Get.snackbar('Success', 'Logged in as $email');
        print('Backend response: $data');
        // TODO: Save token or navigate
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        Get.snackbar('Error', 'Failed to login with Google');
      }
    } on PlatformException catch (e) {
      isLoading.value = false;
      print('Google sign-in platform error: code=${e.code}, message=${e.message}');
      Get.snackbar('Error', e.message ?? 'Google sign-in failed');
    } catch (e) {
      isLoading.value = false;
      print('Google sign-in error: $e');
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}
