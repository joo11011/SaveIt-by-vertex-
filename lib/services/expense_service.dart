import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/expenses_model.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpenseToFirebase(Expense expense, {String? notes}) async {
    try {
      await _firestore.collection('expenses').add({
        'title': expense.title,
        'category': expense.category,
        'amount': expense.amount,
        'date': expense.date,
        'notes': notes ?? '', 
      });
    } catch (e) {

      print("Error adding expense: $e");
      rethrow; 
    }
  }
}
