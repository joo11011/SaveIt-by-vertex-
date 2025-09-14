import 'package:flutter/material.dart';
import 'package:savelt_app/view/Add_new_expenses/Add_new_expenses.dart';
import '../../model/dummy_expenses.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Expenses",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
            ),
          ),
        ],
      ),

      body: dummyExpenses.isEmpty
          ? const Center(child: Text("No expenses added yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyExpenses.length,
              itemBuilder: (context, index) {
                final expense = dummyExpenses[index];

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      dummyExpenses.remove(expense);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Expense Deleted 🗑️"),
                        duration: Duration(seconds: 2),
                      ),
                    );
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
                      leading: Icon(expense.icon, color: expense.color),
                      title: Text(expense.title),
                      subtitle: Text("${expense.category} • ${expense.date}"),
                      trailing: Text(
                        "${expense.amount.toStringAsFixed(2)} USD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: expense.amount < 0 ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ),
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
            label: const Text(
              "Add New Expense",
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
