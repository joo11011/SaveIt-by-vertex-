// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LoginPasswordPage extends StatefulWidget {
//   const LoginPasswordPage({super.key});

//   @override
//   State<LoginPasswordPage> createState() => _LoginPasswordPageState();
// }

// class _LoginPasswordPageState extends State<LoginPasswordPage> {
//   final user = FirebaseAuth.instance.currentUser!;

//   Future<void> _updateEmail() async {
//     TextEditingController emailController =
//         TextEditingController(text: user.email);
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Update Email"),
//         content: TextField(controller: emailController),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
//           TextButton(
//             onPressed: () async {
//               try {
//                 await user.updateEmail(emailController.text.trim());
//                 await FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(user.uid)
//                     .update({'email': emailController.text.trim()});
//                 Get.back();
//                 Get.snackbar("Success", "Email updated");
//               } catch (e) {
//                 Get.snackbar("Error", e.toString());
//               }
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _updatePassword() async {
//     TextEditingController passwordController = TextEditingController();
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Update Password"),
//         content: TextField(
//           controller: passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(hintText: "Enter new password"),
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
//           TextButton(
//             onPressed: () async {
//               try {
//                 await user.updatePassword(passwordController.text.trim());
//                 Get.back();
//                 Get.snackbar("Success", "Password updated");
//               } catch (e) {
//                 Get.snackbar("Error", e.toString());
//               }
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login and Password")),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.email),
//             title: Text("Email: ${user.email}"),
//             trailing: IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: _updateEmail,
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.lock),
//             title: const Text("Change Password"),
//             trailing: IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: _updatePassword,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
