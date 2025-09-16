import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/expenses_model.dart';
import '../core/provider/firestore_service.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID - returns null if not authenticated
  String? get _userId => _auth.currentUser?.uid;

  /// Add expense to user-specific subcollection
  Future<void> addExpenseToFirebase(Expense expense, {String? notes}) async {
    try {
      if (_userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('expenses')
          .add({
        'title': expense.title,
        'category': expense.category,
        'amount': expense.amount,
        'date': expense.date,
        'notes': notes ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update user's total expenses and balance
      await FirestoreService().updateUserFinancials();
    } catch (e) {
      print("Error adding expense: $e");
      rethrow;
    }
  }

  /// Get user-specific expenses stream
  Stream<List<Map<String, dynamic>>> getUserExpensesStream() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList(),
    );
  }

  /// Delete expense
  Future<bool> deleteExpense(String expenseId) async {
    try {
      if (_userId == null) return false;

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('expenses')
          .doc(expenseId)
          .delete();

      await FirestoreService().updateUserFinancials();
      return true;
    } catch (e) {
      print('Delete expense error: $e');
      return false;
    }
  }
}