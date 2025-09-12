// import 'package:final_project/services/auth_service.dart';
// import 'package:final_project/views/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RegisterController extends GetxController {
//   final AuthService _authServices = AuthService();

//   final usernameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   var isPasswordHidden = true.obs;
//   var isConfirmPasswordHidden = true.obs;
//   final formKey = GlobalKey<FormState>();

//   void togglePasswordVisibility() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }

//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
//   }

//   Future<void> register() async {
//     if (formKey.currentState!.validate()) {
//       final username = usernameController.text.trim();
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();
//       final confirmPassword = confirmPasswordController.text.trim();

//       if (password != confirmPassword) {
//         Get.snackbar("Error", "Passwords do not match",
//             snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
//         return;
//       }

//       User? user = await _authServices.registerWithEmail(
//         email: email,
//         password: password,
//         username: username,
//       );

//       if (user != null) {
//         Get.offAll(() => const HomePage());
//       } else {
//         Get.snackbar("Error", "Failed to register",
//             snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
//       }
//     }
//   }
// }











import 'package:final_project/services/auth_service.dart';
import 'package:final_project/views/home_page.dart';
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

      User? user = await _authServices.registerWithEmail(
        email: email,
        password: password,
        username: username,
      );

      if (user != null) {
        Get.offAll(() => const HomePage());
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

  Future<void> registerWithGoogle() async {
    User? user = await _authServices.signInWithGoogle();
    if (user != null) Get.offAll(() => const HomePage());
  }

  Future<void> registerWithFacebook() async {
    User? user = await _authServices.signInWithFacebook();
    if (user != null) Get.offAll(() => const HomePage());
  }

  Future<void> registerAnonymously() async {
    User? user = await _authServices.signInAnonymously();
    if (user != null) Get.offAll(() => const HomePage());
  }

}
