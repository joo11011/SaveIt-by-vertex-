import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../core/provider/currency_provider.dart';
import '../../core/provider/firestore_service.dart';
import '../add_installments_screen/Add_installments_screen.dart';
import 'widgets/balance_card.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateAllocationPercentage(double balance, double income) {
    if (income <= 0) return 0.0;
    return math.min((balance / income) * 100, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Balance'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<CurrencyProvider>(
            builder: (context, currencyProvider, child) {
              return PopupMenuButton<String>(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currencyProvider.currencyFlag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      currencyProvider.selectedCurrency,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 16,
                    ),
                  ],
                ),
                onSelected: (String currency) async {
                  await currencyProvider.setCurrency(currency);
                },
                itemBuilder: (BuildContext context) {
                  return currencyProvider.availableCurrencies.map((String c) {
                    Map<String, String> info = currencyProvider.getCurrencyInfo(
                      c,
                    );
                    return PopupMenuItem<String>(
                      value: c,
                      child: Row(
                        children: [
                          Text(
                            info['flag']!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(c),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              info['name']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          if (currencyProvider.selectedCurrency == c)
                            const Icon(
                              Icons.check,
                              color: Color(0xFF4CAF50),
                              size: 16,
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // الكارت الرئيسي
                const BalanceCard(),

                const SizedBox(height: 40),

                // Progress Indicator
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey[200]!,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return StreamBuilder<Map<String, dynamic>>(
                            stream: firestoreService
                                .getUserFinancialsStream(), 
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator(
                                  strokeWidth: 12,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey,
                                  ),
                                );
                              }

                              final userData = snapshot.data!;
                              final balance = (userData['balance'] ?? 0.0)
                                  .toDouble();
                              final income = (userData['income'] ?? 0.0)
                                  .toDouble();

                              final allocationPercentage =
                                  _calculateAllocationPercentage(
                                    balance,
                                    income,
                                  );

                              return CircularProgressIndicator(
                                value: (allocationPercentage / 100) *
                                    _progressAnimation.value,
                                strokeWidth: 12,
                                backgroundColor: Colors.transparent,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: 'Home',
              isActive: false,
              onTap: () => Navigator.of(context).pop(),
            ),
            _buildNavItem(
              icon: Icons.add_circle_outline,
              label: 'Add Installment',
              isActive: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddInstallmentScreen(),
                  ),
                );
              },
            ),
            _buildNavItem(
              icon: Icons.account_balance_wallet,
              label: 'Balance',
              isActive: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
