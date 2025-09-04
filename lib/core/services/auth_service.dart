import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _createUserDocument(result.user!, username);
      
      return result;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user, String username) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
      'currency': 'SAR', // Default currency
      'balance': 0.0,
      'income': 0.0,
      'expenses': 0.0,
      'savings': 0.0,
    });
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // Get user data from Firestore
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

  // Update user currency preference
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
}

