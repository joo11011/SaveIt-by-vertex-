import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:savelt_app/services/income_service.dart';
import 'income_items.dart';

class income_list extends StatelessWidget {
  final List<Map<String, dynamic>> incomes;
  final List<String> docIds;

  const income_list({super.key, required this.incomes, required this.docIds});

  @override
  Widget build(BuildContext context) {
    final IncomeService _incomeService = IncomeService();

    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        final income = incomes[index];
        return Dismissible(
          key: Key(docIds[index]),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            final incomeId = docIds[index];
            try {
              await _incomeService.deleteIncome(incomeId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('income deleted'.tr),
                  duration: Duration(seconds: 2),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete income: $e'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: incomeitems(
            tit: income['title'] ?? 'N/A', // Corrected key to 'title'
            subtit: income['note'] ?? 'No note',
            amount: (income['amount'] as num?)?.toDouble() ?? 0.0,
            icon: Icons.attach_money,
          ),
        );
      },
    );
  }
}