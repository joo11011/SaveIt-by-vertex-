import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final double amount;
  final String date;
  final Color color;

  const ExpenseItem({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: color.withAlpha((0.2 * 255).round()),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          category,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${amount.toStringAsFixed(2)} USD",
              style: TextStyle(
                color: amount < 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
