import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../model/user_model.dart';

class UserProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('User data not found');
      }

      _currentUser = UserModel.fromMap(docSnapshot.data()!);
    } catch (e) {
      _currentUser = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUserData() {
    _currentUser = null;
    notifyListeners();
  }
}
