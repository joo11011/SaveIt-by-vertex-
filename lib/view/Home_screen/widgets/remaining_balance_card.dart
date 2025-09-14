import 'package:flutter/material.dart';

class RemainingBalanceCard extends StatelessWidget {
  final String balance;
  final String currency;
  final String income;
  final String expenses;

  const RemainingBalanceCard({
    super.key,
    required this.balance,
    required this.currency,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 250,
        height: 250,
        child: Card(
          elevation: 10.0,
          margin: const EdgeInsets.all(10.0),
          shape: const CircleBorder(),
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Remaining Balance',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    balance,
                    style: const TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    currency,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoColumn('Income', income, Colors.green),
                      const SizedBox(width: 20),
                      _buildInfoColumn('Expenses', expenses, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
