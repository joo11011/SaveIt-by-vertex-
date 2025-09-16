import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class AddIncomeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddIncomeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add, size: 40, color: Colors.white),
        label: Text(
          "add_income".tr,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
