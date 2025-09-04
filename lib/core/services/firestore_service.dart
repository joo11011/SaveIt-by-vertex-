import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/installment_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<bool> addInstallment(InstallmentModel installment) async {
    try {
      if (_userId == null) {
        debugPrint('User not authenticated');
        return false;
      }

      if (installment.installmentName.trim().isEmpty) {
        debugPrint('Installment name is empty');
        return false;
      }

      if (installment.totalAmount <= 0) {
        debugPrint('Invalid amount: ${installment.totalAmount}');
        return false;
      }

      if (installment.category.trim().isEmpty) {
        debugPrint('Category is empty');
        return false;
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('installments')
          .add(installment.toMap());

      await _updateUserFinancials();

      return true;
    } catch (e) {
      debugPrint('Add installment error: $e');
      return false;
    }
  }

  Stream<List<InstallmentModel>> getInstallmentsStream() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('installments')
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) {
          try {
            return InstallmentModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint('Error parsing installment ${doc.id}: $e');
            return null;
          }
        })
            .where((installment) => installment != null)
            .cast<InstallmentModel>()
            .toList();
      } catch (e) {
        debugPrint('Error processing installments stream: $e');
        return <InstallmentModel>[];
      }
    }).handleError((error) {
      debugPrint('Installments stream error: $error');
      return <InstallmentModel>[];
    });
  }

  // Get user financial data stream
  Stream<Map<String, dynamic>> getUserFinancialsStream() {
    if (_userId == null) {
      return Stream.value({
        'balance': 0.0,
        'income': 0.0,
        'expenses': 0.0,
        'savings': 0.0,
        'totalInstallments': 0.0,
      });
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .snapshots()
        .map((snapshot) {
      try {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() ?? {};

          return {
            'balance': (data['balance'] ?? 0.0).toDouble(),
            'income': (data['income'] ?? 0.0).toDouble(),
            'expenses': (data['expenses'] ?? 0.0).toDouble(),
            'savings': (data['savings'] ?? 0.0).toDouble(),
            'totalInstallments': (data['totalInstallments'] ?? 0.0).toDouble(),
            'currency': data['currency'] ?? 'SAR',
            'username': data['username'] ?? '',
            'email': data['email'] ?? '',
          };
        }
        return {
          'balance': 0.0,
          'income': 0.0,
          'expenses': 0.0,
          'savings': 0.0,
          'totalInstallments': 0.0,
          'currency': 'SAR',
          'username': '',
          'email': '',
        };
      } catch (e) {
        debugPrint('Error processing user financials: $e');
        return {
          'balance': 0.0,
          'income': 0.0,
          'expenses': 0.0,
          'savings': 0.0,
          'totalInstallments': 0.0,
          'currency': 'SAR',
          'username': '',
          'email': '',
        };
      }
    }).handleError((error) {
      debugPrint('User financials stream error: $error');
      return {
        'balance': 0.0,
        'income': 0.0,
        'expenses': 0.0,
        'savings': 0.0,
        'totalInstallments': 0.0,
        'currency': 'SAR',
        'username': '',
        'email': '',
      };
    });
  }

  // Update user financial data
  Future<void> _updateUserFinancials() async {
    if (_userId == null) return;

    try {
      // Get all installments
      QuerySnapshot installmentsSnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('installments')
          .get();

      double totalInstallments = 0.0;
      for (var doc in installmentsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalInstallments += (data['totalAmount'] ?? 0.0).toDouble();
      }

      // Get current user data
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      if (!userDoc.exists) {
        // Create user document if it doesn't exist
        await _firestore.collection('users').doc(_userId).set({
          'uid': _userId,
          'email': _auth.currentUser?.email ?? '',
          'username': _auth.currentUser?.displayName ?? 'User',
          'createdAt': FieldValue.serverTimestamp(),
          'currency': 'SAR',
          'balance': 0.0,
          'income': 0.0,
          'expenses': 0.0,
          'savings': 0.0,
          'totalInstallments': totalInstallments,
        });
        return;
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      double income = (userData['income'] ?? 0.0).toDouble();
      double expenses = (userData['expenses'] ?? 0.0).toDouble();
      double savings = (userData['savings'] ?? 0.0).toDouble();

      // Calculate new balance
      double balance = income - expenses - totalInstallments + savings;

      // Update user document
      await _firestore.collection('users').doc(_userId).update({
        'balance': balance,
        'totalInstallments': totalInstallments,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Update financials error: $e');
    }
  }

  // Update user income
  Future<void> updateUserIncome(double income) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('users').doc(_userId).update({
        'income': income,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _updateUserFinancials();
    } catch (e) {
      debugPrint('Update income error: $e');
    }
  }

  // Update user expenses
  Future<void> updateUserExpenses(double expenses) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('users').doc(_userId).update({
        'expenses': expenses,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _updateUserFinancials();
    } catch (e) {
      debugPrint('Update expenses error: $e');
    }
  }

  // Update user savings
  Future<void> updateUserSavings(double savings) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('users').doc(_userId).update({
        'savings': savings,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _updateUserFinancials();
    } catch (e) {
      debugPrint('Update savings error: $e');
    }
  }

  // Delete installment
  Future<bool> deleteInstallment(String installmentId) async {
    try {
      if (_userId == null) return false;

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('installments')
          .doc(installmentId)
          .delete();

      await _updateUserFinancials();
      return true;
    } catch (e) {
      debugPrint('Delete installment error: $e');
      return false;
    }
  }

  // Mark installment as paid
  Future<bool> markInstallmentAsPaid(String installmentId) async {
    try {
      if (_userId == null) return false;

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('installments')
          .doc(installmentId)
          .update({
        'isPaid': true,
        'paidDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _updateUserFinancials();
      return true;
    } catch (e) {
      debugPrint('Mark paid error: $e');
      return false;
    }
  }
}