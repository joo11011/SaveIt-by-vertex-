import '../services/auth_service.dart';
import '../view/Home_screen/Home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final AuthService _authServices = AuthService();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // تسجيل مستخدم جديد بالبريد + كلمة السر
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      final username = usernameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        Get.snackbar(
          "Error",
          "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        return;
      }

      // **مهم**: هنا بنستدعي الدالة الصحيحة من AuthService
      UserCredential? userCredential = await _authServices
          .registerWithEmailAndPassword(email, password, username);

      if (userCredential != null && userCredential.user != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar(
          "Error",
          "Failed to register",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // تسجيل/تسجيل دخول بواسطة جوجل
  Future<void> registerWithGoogle() async {
    User? user = await _authServices.signInWithGoogle();
    if (user != null) Get.offAll(() => const HomeScreen());
  }

  // // تسجيل بواسطة فيسبوك
  // Future<void> registerWithFacebook() async {
  //   User? user = await _authServices.signInWithFacebook();
  //   if (user != null) Get.offAll(() => const HomeScreen());
  // }

  // تسجيل كمجهول
  Future<void> registerAnonymously() async {
    User? user = await _authServices.signInAnonymously();
    if (user != null) Get.offAll(() => const HomeScreen());
  }
}
