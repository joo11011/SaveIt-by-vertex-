import 'package:flutter/material.dart';
import 'package:savelt_app/view/Add_new_expenses/models/category_model.dart';
import 'package:savelt_app/view/Add_new_expenses/models/dummy_categories.dart';
import 'package:savelt_app/view/Expenses_screen/models/dummy_expenses.dart';
import 'package:savelt_app/view/Expenses_screen/models/expenses_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: "120.00",
  );
  final TextEditingController _nameController = TextEditingController(
    text: "Grocery Shopping",
  );
  final TextEditingController _notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int selectedCategoryIndex = 2; 
    final List<Map<String, dynamic>> _localExpenses = [];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showAddCategoryDialog() {
    final TextEditingController _customCategoryController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Custom Category"),
          content: TextField(
            controller: _customCategoryController,
            decoration: const InputDecoration(hintText: "Enter category name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_customCategoryController.text.isNotEmpty) {
                  setState(() {
                    dummyCategories.insert(
                      dummyCategories.length - 1,
                      CategoryModel(
                        label: _customCategoryController.text,
                        icon: Icons.category,
                      ),
                    );
                    selectedCategoryIndex = dummyCategories.length - 2;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _saveExpense() {
    final expense = Expense(
      icon: dummyCategories[selectedCategoryIndex].icon,
      title: _nameController.text,
      category: dummyCategories[selectedCategoryIndex].label,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      date: "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
      color: Colors.red, 
    );

    setState(() {
      dummyExpenses.insert(0, expense); 
    });

    if (mounted) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Expense Added ✅")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Expense"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  prefixText: "\$ ",
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),

              const Text("Expense Name"),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter expense name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Category"),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: dummyCategories.length,
                itemBuilder: (context, index) {
                  final category = dummyCategories[index];
                  final bool isSelected = selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      if (category.label == "Other") {
                        _showAddCategoryDialog();
                      } else {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.red : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? Colors.red.withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category.icon,
                            color: isSelected ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.red : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text("Date"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
                      ),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Notes (Optional)"),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "e.g. Weekly groceries from the supermarket",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _saveExpense,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add Expense",
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
