import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ✅ Register with email & password + save user document
  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _createUserDocument(result.user!, username);
      return result;
    } catch (e) {
      Get.snackbar(
        "Register Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  // ✅ Sign in with email & password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  // ✅ Sign in with Google
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

  // ✅ Sign in with Facebook
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

  // ✅ Sign in Anonymously
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        await _createUserDocument(user, "Anonymous");
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

  // ✅ Sign out (Email / Google / Facebook)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // ✅ Reset password
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

  // ✅ Get user data from Firestore
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

  // ✅ Update user currency
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

  // 📌 Create user document in Firestore (shared function)
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
}
