import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Balance")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          final income = (data['income'] ?? 0).toDouble();
          final expenses = (data['expenses'] ?? 0).toDouble();
          final balance = (data['balance'] ?? 0).toDouble();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "SAR ${balance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: balance >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildStatCard(
                          title: 'Income',
                          value: income,
                          color: Colors.green,
                        ),
                        _buildStatCard(
                          title: 'Expenses',
                          value: expenses,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "SAR ${value.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
