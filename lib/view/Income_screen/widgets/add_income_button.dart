import 'package:flutter/material.dart';

class AddIncomeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddIncomeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add, size: 40, color: Colors.white),
        label: Text(
          "Add New Income",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
