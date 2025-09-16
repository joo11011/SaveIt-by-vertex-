// Refactored lib/view/Expenses_screen/Expenses_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:savelt_app/view/Add_new_expenses/Add_new_expenses.dart';
import '../../services/expense_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'expense'.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _expenseService.getUserExpensesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final expenses = snapshot.data ?? [];
          if (expenses.isEmpty) {
            return Center(child: Text('no expense added yet'.tr));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  final expenseId = expense['id'] as String?;
                  if (expenseId != null) {
                    try {
                      await _expenseService.deleteExpense(expenseId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${'expense deleted'.tr} 🗑️"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to delete expense: $e"),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                      // Re-insert the item into the list if deletion fails
                      setState(() {
                        expenses.insert(index, expense);
                      });
                    }
                  }
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.green),
                    title: Text(expense['title'] ?? ''),
                    subtitle: Text(expense['category'] ?? ''),
                    trailing: Text(
                      '\$${expense['amount']?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
              setState(() {});
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'add_expense'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}