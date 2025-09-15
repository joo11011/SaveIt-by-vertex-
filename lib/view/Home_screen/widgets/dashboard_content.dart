import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:savelt_app/model/dummy_expenses.dart';
import 'package:savelt_app/view/Expenses_screen/Expenses_screen.dart';
import 'package:savelt_app/view/Home_screen/widgets/grid_item.dart';
import 'package:savelt_app/view/Home_screen/widgets/remaining_balance_card.dart';
import 'package:savelt_app/view/Income_screen/Income_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savelt_app/view/Installments_screen/Installments_screen.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  Future<double> getTotalIncome() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('incomes')
        .get();
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data.containsKey('amount')) {
        total += (data['amount'] as num).toDouble();
      }
    }
    return total;
  }

  Future<double> getTotalInstallments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('installments')
        .get();
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data.containsKey('amount')) {
        total += (data['amount'] as num).toDouble();
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<double>>(
        future: Future.wait([getTotalIncome(), getTotalInstallments()]),
        builder: (context, snapshot) {
          final incomeTotal = snapshot.data?[0] ?? 0.0;
          final installmentsTotal = snapshot.data?[1] ?? 0.0;

          return Column(
            children: [
              RemainingBalanceCard(
                balance: (incomeTotal - totalExpenses).toStringAsFixed(2),
                currency: 'SAR',
                income: '${incomeTotal.toStringAsFixed(2)}',
                expenses: '${totalExpenses.toStringAsFixed(2)}',
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16.0),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    GridItem(
                      icon: Icons.arrow_downward_sharp,
                      title: 'income'.tr,
                      amount: '${incomeTotal.toStringAsFixed(2)} SAR',
                      color: Colors.green,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => income_screen(),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                    GridItem(
                      icon: Icons.arrow_outward_sharp,
                      title: 'expense'.tr,
                      amount: '${totalExpenses.toStringAsFixed(2)} SAR',
                      color: Colors.red,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExpensesScreen(),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                    GridItem(
                      icon: Icons.account_balance_wallet,
                      title: 'savings'.tr,
                      amount: '1,000 SAR', // ممكن تعملها ديناميكي بعدين
                      color: Colors.blue,
                    ),
                    GridItem(
                      icon: Icons.payment,
                      title: 'installments'.tr,
                      amount:
                          '${installmentsTotal.toStringAsFixed(2)} SAR', // 🔹 الآن ديناميكي
                      color: Colors.yellow,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstallmentsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
