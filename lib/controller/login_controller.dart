// import '../services/auth_service.dart';
// import '../view/Home_screen/Home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginController extends GetxController {
//   final AuthService _authServices = AuthService();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   var isPasswordVisible = true.obs;
//   final formKey = GlobalKey<FormState>();

//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   //  تسجيل الدخول بالايميل
//   Future<void> login() async {
//     if (formKey.currentState!.validate()) {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();

//       UserCredential? userCredential = await _authServices
//           .signInWithEmailAndPassword(email, password);

//       if (userCredential != null && userCredential.user != null) {
//         Get.offAll(() => const HomeScreen());
//       } else {
//         Get.snackbar(
//           "Error",
//           "Email or Password incorrect!",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//         );
//       }
//     }
//   }

//   //  تسجيل الدخول بجوجل
//   Future<void> loginWithGoogle() async {
//     User? user = await _authServices.signInWithGoogle();
//     if (user != null) Get.offAll(() => const HomeScreen());
//   }

//   // //  تسجيل الدخول بالفيسبوك
//   // Future<void> loginWithFacebook() async {
//   //   User? user = await _authServices.signInWithFacebook();
//   //   if (user != null) Get.offAll(() => const HomeScreen());
//   // }

//   //  تسجيل الدخول كمجهول
//   Future<void> loginAnonymously() async {
//     User? user = await _authServices.signInAnonymously();
//     if (user != null) Get.offAll(() => const HomeScreen());
//   }
// }

import '../services/auth_service.dart';
import '../view/Home_screen/Home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../core/provider/user_provider.dart'; // استيراد UserProvider

class LoginController extends GetxController {
  final AuthService _authServices = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = true.obs;
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  //  تسجيل الدخول بالايميل
  Future<void> login(BuildContext context) async {
    // مررت context
    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      UserCredential? userCredential = await _authServices
          .signInWithEmailAndPassword(email, password);

      if (userCredential != null && userCredential.user != null) {
        // تحميل بيانات المستخدم بعد تسجيل الدخول
        await Provider.of<UserProvider>(context, listen: false).loadUserData();

        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar(
          "Error",
          "Email or Password incorrect!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  //  تسجيل الدخول بجوجل
  Future<void> loginWithGoogle(BuildContext context) async {
    User? user = await _authServices.signInWithGoogle();
    if (user != null) {
      await Provider.of<UserProvider>(context, listen: false).loadUserData();
      Get.offAll(() => const HomeScreen());
    }
  }

  // //  تسجيل الدخول بالفيسبوك
  // Future<void> loginWithFacebook() async {
  //   User? user = await _authServices.signInWithFacebook();
  //   if (user != null) Get.offAll(() => const HomeScreen());
  // }

  //  تسجيل الدخول كمجهول
  Future<void> loginAnonymously(BuildContext context) async {
    User? user = await _authServices.signInAnonymously();
    if (user != null) {
      await Provider.of<UserProvider>(context, listen: false).loadUserData();
      Get.offAll(() => const HomeScreen());
    }
  }
}
