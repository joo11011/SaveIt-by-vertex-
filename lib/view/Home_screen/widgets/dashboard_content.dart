import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:savelt_app/core/provider/firestore_service.dart';
import 'package:savelt_app/view/Expenses_screen/Expenses_screen.dart';
import 'package:savelt_app/view/Home_screen/widgets/grid_item.dart';
import 'package:savelt_app/view/Home_screen/widgets/remaining_balance_card.dart';
import 'package:savelt_app/view/Income_screen/Income_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savelt_app/view/Installments_screen/Installments_screen.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user ID - returns null if not authenticated
  String? get _userId => _auth.currentUser?.uid;

  /// Get user-specific financial data stream
  Stream<Map<String, dynamic>> getUserFinancialsStream() {
    if (_userId == null) return Stream.value({});

    return _firestore.collection('users').doc(_userId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return {};
    });
  }

  @override
  void initState() {
    super.initState();
    FirestoreService().updateUserFinancials();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<Map<String, dynamic>>(
        stream: getUserFinancialsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final userData = snapshot.data!;
          final income = (userData['income'] ?? 0.0).toDouble();
          final expenses = (userData['expenses'] ?? 0.0).toDouble();
          final savings = (userData['savings'] ?? 0.0).toDouble();
          final totalInstallments = (userData['totalInstallments'] ?? 0.0)
              .toDouble();
          final balance = (userData['balance'] ?? 0.0).toDouble();
          final currency = userData['currency'] ?? 'SAR';

          return Column(
            children: [
              RemainingBalanceCard(
                balance: balance.toStringAsFixed(2),
                currency: currency,
                income: income.toStringAsFixed(2),
                expenses: expenses.toStringAsFixed(2),
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
                      amount: '${income.toStringAsFixed(2)} $currency',
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
                      amount: '${expenses.toStringAsFixed(2)} $currency',
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
                      amount: '${savings.toStringAsFixed(2)} $currency',
                      color: Colors.blue,
                    ),
                    GridItem(
                      icon: Icons.payment,
                      title: 'installments'.tr,
                      amount:
                          '${totalInstallments.toStringAsFixed(2)} $currency',
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
