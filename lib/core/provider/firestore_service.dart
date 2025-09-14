import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/installment_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Add installment
  Future<bool> addInstallment(InstallmentModel installment) async {
    try {
      if (_userId == null) return false;

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('installments')
          .add(installment.toMap());

      // Update user's total installments amount
      await _updateUserFinancials();

      return true;
    } catch (e) {
      print('Add installment error: $e');
      return false;
    }
  }

  // Get installments stream
  Stream<List<InstallmentModel>> getInstallmentsStream() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('installments')
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => InstallmentModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get user financial data stream
  Stream<Map<String, dynamic>> getUserFinancialsStream() {
    if (_userId == null) return Stream.value({});

    return _firestore.collection('users').doc(_userId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return {};
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
        final data = doc.data() as Map<String, dynamic>;
        final rawAmount = data['totalAmount'] ?? 0;
        final amount = (rawAmount is int)
            ? rawAmount.toDouble()
            : rawAmount as double;
        totalInstallments += amount;
      }

      // Get current user data
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      double income = userData['income'] ?? 0.0;
      double expenses = userData['expenses'] ?? 0.0;
      double savings = userData['savings'] ?? 0.0;

      // Calculate new balance
      double balance = income - expenses - totalInstallments + savings;

      // Update user document
      await _firestore.collection('users').doc(_userId).update({
        'balance': balance,
        'totalInstallments': totalInstallments,
      });
    } catch (e) {
      print('Update financials error: $e');
    }
  }

  // Update user income
  Future<void> updateUserIncome(double income) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('users').doc(_userId).update({
        'income': income,
      });
      await _updateUserFinancials();
    } catch (e) {
      print('Update income error: $e');
    }
  }

  // Update user expenses
  Future<void> updateUserExpenses(double expenses) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('users').doc(_userId).update({
        'expenses': expenses,
      });
      await _updateUserFinancials();
    } catch (e) {
      print('Update expenses error: $e');
    }
  }

  // Update user savings
  Future<void> updateUserSavings(double savings) async {
    if (_userId == null) return;

    try {
      await _firestore.collection('users').doc(_userId).update({
        'savings': savings,
      });
      await _updateUserFinancials();
    } catch (e) {
      print('Update savings error: $e');
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
      print('Delete installment error: $e');
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
          .update({'isPaid': true, 'paidDate': FieldValue.serverTimestamp()});

      await _updateUserFinancials();
      return true;
    } catch (e) {
      print('Mark paid error: $e');
      return false;
    }
  }
}
