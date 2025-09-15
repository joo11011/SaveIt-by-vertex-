import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:savelt_app/view/Balance_screen/Balance_screen.dart';

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
    final double incomeVal = double.tryParse(income) ?? 0.0;
    final double expensesVal = double.tryParse(expenses) ?? 0.0;
    final double balanceVal = double.tryParse(balance) ?? 0.0;
    final double progress = incomeVal > 0 ? (expensesVal / incomeVal) : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BalanceScreen()),
        );
      },
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
              ),
            ),
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress < 0.7
                      ? Colors.green
                      : (progress < 1.0 ? Colors.orange : Colors.red),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'remaining_balance'.tr,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  balanceVal.toStringAsFixed(2),
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
                    _buildInfoColumn(
                      'income'.tr,
                      "$incomeVal $currency",
                      Colors.green.shade600,
                    ),
                    const SizedBox(width: 20),
                    _buildInfoColumn(
                      'expense'.tr,
                      "$expensesVal $currency",
                      Colors.red.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
