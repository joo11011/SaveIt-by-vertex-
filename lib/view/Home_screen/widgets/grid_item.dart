import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final Color color;
  final VoidCallback? onTap;

  const GridItem({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withAlpha((0.2 * 255).toInt()),
                child: Icon(icon, size: 40, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
