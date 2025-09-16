// Refactored lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:savelt_app/core/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; //  إضافة جديدة
import 'package:provider/provider.dart'; // إضافة علشان نستخدم UserProvider

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //  Register with email & password + save user document
  Future<UserCredential?> registerWithEmailAndPassword(
      String email,
      String password,
      String username,
      ) async {
    try {
      // Validate inputs
      if (email.trim().isEmpty ||
          password.trim().isEmpty ||
          username.trim().isEmpty) {
        throw FirebaseAuthException(code: 'invalid-argument', message: 'All fields are required');
      }

      if (password.length < 6) {
        throw FirebaseAuthException(code: 'weak-password');
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (result.user != null) {
        await _createUserDocument(result.user!, username.trim());

        // Send email verification
        await result.user!.sendEmailVerification();
      }

      return result;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Register Failed",
        _handleAuthError(e.code),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        "Register Failed",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  //  Sign in with email & password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      // Validate inputs
      if (email.trim().isEmpty || password.trim().isEmpty) {
        throw FirebaseAuthException(code: 'invalid-argument', message: 'Email and password are required');
      }

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check if email is verified
      if (result.user != null && !result.user!.emailVerified) {
        Get.snackbar(
          "Email Not Verified",
          "Please verify your email before signing in",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        // Sign out the user since email is not verified
        await _auth.signOut();
        return null;
      }

      return result;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        _handleAuthError(e.code),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  //  Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _createUserDocument(user, user.displayName ?? "No Name");
      }
      return user;
    } catch (e) {
      Get.snackbar(
        "Google Sign-In Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  //  Sign in with Facebook
  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final facebookAuthCredential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        final userCredential = await _auth.signInWithCredential(
          facebookAuthCredential,
        );
        final user = userCredential.user;

        if (user != null) {
          await _createUserDocument(user, user.displayName ?? "No Name");
        }
        return user;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        "Facebook Sign-In Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  //  Sign in Anonymously
  Future<User?> signInAnonymously({String username = "Anonymous"}) async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        await _createUserDocument(user, username); //  ياخد اللي المستخدم حطه
      }
      return user;
    } catch (e) {
      Get.snackbar(
        "Anonymous Sign-In Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  //  Sign out (Email / Google / Facebook)
  Future<void> signOut(BuildContext context) async {
    //  مررت context
    try {
      final user = _auth.currentUser;

      //  لو مجهول امسح الشات بتاعه
      if (user != null && user.isAnonymous) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("chat_history_${user.uid}");
      }

      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();

      // مسح بيانات المستخدم من UserProvider بعد تسجيل الخروج
      Provider.of<UserProvider>(context, listen: false).clearUserData();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  //  Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      Get.snackbar(
        "Reset Password Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  //  Get user data from Firestore
  Future<DocumentSnapshot?> getUserData() async {
    try {
      if (currentUser != null) {
        return await _firestore.collection('users').doc(currentUser!.uid).get();
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  //  Update user currency
  Future<void> updateUserCurrency(String currency) async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'currency': currency,
        });
      }
    } catch (e) {
      print('Update currency error: $e');
    }
  }

  //  Create user document in Firestore (shared function)
  Future<void> _createUserDocument(User user, String username) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email ?? "Anonymous",
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
      'currency': 'SAR', // Default currency
      'balance': 0.0,
      'income': 0.0,
      'expenses': 0.0,
      'savings': 0.0,
      'totalInstallments': 0.0,
    }, SetOptions(merge: true));
  }

  /// Handle Firebase authentication errors
  String _handleAuthError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}