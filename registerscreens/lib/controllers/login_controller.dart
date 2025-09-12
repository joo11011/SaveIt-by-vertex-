// import 'package:final_project/services/auth_service.dart';
// import 'package:final_project/views/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginController extends GetxController {
//   final AuthService _authServices = AuthService();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   var isPasswordVisible = false.obs;
//   final formKey = GlobalKey<FormState>();

//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   Future<void> login() async {
//     if (formKey.currentState!.validate()) {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();

//       User? user = await _authServices.signInWithEmail(
//         email: email,
//         password: password,
//       );

//       if (user != null) {
//         Get.offAll(() => const HomePage());
//       } else {
//         Get.snackbar("Error", "Email or Password incorrect!",
//             snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
//       }
//     }
//   }

//   Future<void> loginWithGoogle() async {
//     User? user = await _authServices.signInWithGoogle();
//     if (user != null) Get.offAll(() => const HomePage());
//   }

//   Future<void> loginWithFacebook() async {
//     User? user = await _authServices.signInWithFacebook();
//     if (user != null) Get.offAll(() => const HomePage());
//   }
// }
















// import 'package:final_project/services/auth_service.dart';
// import 'package:final_project/views/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginController extends GetxController {
//   final AuthService _authServices = AuthService();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   var isPasswordVisible = false.obs;
//   final formKey = GlobalKey<FormState>();

//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   Future<void> login() async {
//     if (formKey.currentState!.validate()) {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();

//       User? user = await _authServices.signInWithEmail(
//         email: email,
//         password: password,
//       );

//       if (user != null) {
//         Get.offAll(() => const HomePage());
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

//   Future<void> loginWithGoogle() async {
//     User? user = await _authServices.signInWithGoogle();
//     if (user != null) Get.offAll(() => const HomePage());
//   }

//   Future<void> loginWithFacebook() async {
//     User? user = await _authServices.signInWithFacebook();
//     if (user != null) Get.offAll(() => const HomePage());
//   }
// }













import 'package:final_project/services/auth_service.dart';
import 'package:final_project/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthService _authServices = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = true.obs;

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      User? user = await _authServices.signInWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        Get.offAll(() => const HomePage());
      } else {
        Get.snackbar("Error", "Email or Password incorrect!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    }
  }

  Future<void> loginWithGoogle() async {
    User? user = await _authServices.signInWithGoogle();
    if (user != null) Get.offAll(() => const HomePage());
  }

  Future<void> loginWithFacebook() async {
    User? user = await _authServices.signInWithFacebook();
    if (user != null) Get.offAll(() => const HomePage());
  }

  Future<void> loginAnonymously() async {
    User? user = await _authServices.signInAnonymously();
    if (user != null) Get.offAll(() => const HomePage());
  }


}


