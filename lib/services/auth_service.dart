// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:final_project/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   User? get currentUser => _auth.currentUser;

//   // تسجيل مستخدم جديد وتخزين بياناته في Firestore
//   Future<User?> registerWithEmail({
//     required String email,
//     required String password,
//     required String username,
//   }) async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = userCredential.user;

//       if (user != null) {
//         final newUser = UserModel(
//           uid: user.uid,
//           email: email,
//           username: username,
//         );

//         await _firestore.collection("users").doc(user.uid).set(newUser.toMap());
//       }

//       return user;
//     } catch (e) {
//       //print("Error in Register: $e");
//       Get.snackbar("Login Failed", e.toString(),
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red);

//       return null;
//     }
//   }

//   // تسجيل الدخول
//   Future<User?> signInWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) { //error handling
//       //print("Error in SignIn: $e");
//       Get.snackbar("Login Failed", e.toString(),
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red);

//       return null;
//     }
//   }

//   // Google Sign In
//   Future<User?> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) return null;

//     final googleAuth = await googleUser.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final userCredential = await _auth.signInWithCredential(credential);
//     final user = userCredential.user;

//     if (user != null) {
//       // هنا نسجل أو نحدث بيانات Firestore
//       await _firestore.collection("users").doc(user.uid).set({
//         "uid": user.uid,
//         "email": user.email,
//         "username": user.displayName ?? "No Name",
//       }, SetOptions(merge: true)); // يخلي التحديث مش overwrite
//     }

//     return user;
//   } catch (e) {
//     //print("Error in Google SignIn: $e");
//     Get.snackbar("Login Failed", e.toString(),
//     snackPosition: SnackPosition.BOTTOM,
//     backgroundColor: Colors.red);

//     return null;
//   }
// }

//   // Facebook Sign In
//   Future<User?> signInWithFacebook() async {
//   try {
//     final LoginResult result = await FacebookAuth.instance.login();

//     if (result.status == LoginStatus.success) {
//       final OAuthCredential credential =
//           FacebookAuthProvider.credential(result.accessToken!.tokenString);

//       final userCredential = await _auth.signInWithCredential(credential);
//       final user = userCredential.user;

//       if (user != null) {
//         // هنا نسجل أو نحدث بيانات Firestore
//         await _firestore.collection("users").doc(user.uid).set({
//           "uid": user.uid,
//           "email": user.email,
//           "username": user.displayName ?? "No Name",
//         }, SetOptions(merge: true)); // update أو add حسب الحالة
//       }

//       return user;
//     } else {
//       //print("Facebook login failed: ${result.message}");

//       Get.snackbar("Login Failed", e.toString(),
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red
//       );

//       return null;
//     }
//   } catch (e) {
//     //print("Error in Facebook SignIn: $e");

//     Get.snackbar("Login Failed", e.toString(),
//     snackPosition: SnackPosition.BOTTOM,
//     backgroundColor: Colors.red);

//     return null;
//   }
// }

//   // تسجيل الخروج
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await GoogleSignIn().signOut();
//     await FacebookAuth.instance.logOut();
//   }
// }














import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // تسجيل مستخدم جديد
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final newUser =
            UserModel(uid: user.uid, email: email, username: username);

        await _firestore.collection("users").doc(user.uid).set(newUser.toMap());
      }
      return user;
    } catch (e) {
      //print("Error in Register: $e");
      
      return null;
    }
  }

  // تسجيل الدخول بالبريد
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      //print("Error in SignIn: $e");

      //error handling
      Get.snackbar("Login Failed", e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red);
      return null;
    }
  }

  // تسجيل الدخول بجوجل
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "username": user.displayName ?? "No Name",
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      //print("Error in Google SignIn: $e");

      //error handling
      Get.snackbar("Login Failed", e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red);
      return null;
    }
  }

  // تسجيل الدخول بالفيسبوك
  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        final userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);
        final user = userCredential.user;

        if (user != null) {
          await _firestore.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "email": user.email,
            "username": user.displayName ?? "No Name",
          }, SetOptions(merge: true));
        }
        return user;
      }
      return null;
    } catch (e) {
      //print("Error in Facebook SignIn: $e");

      //error handling
      Get.snackbar("Login Failed", e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red);

      return null;
    }
  }

  //تسجيل الدخول كمجهول الهويه
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        // نخزن بيانات أساسية في Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email ?? "Anonymous",
          "username": "Anonymous",
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
      return null;
    }
  }


  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }
}
