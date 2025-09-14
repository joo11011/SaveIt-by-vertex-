import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../core/provider/currency_provider.dart';
import '../../core/provider/firestore_service.dart';
import '../add_installments_screen/Add_installments_screen.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen>
    with TickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Balance',
          style: TextStyle(
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
                  // If setCurrency does not return a value, you cannot check for success here.
                  // If you need to show a SnackBar on failure, update setCurrency to return a bool.
                },
                itemBuilder: (BuildContext context) {
                  return currencyProvider.availableCurrencies.map((
                    String currency,
                  ) {
                    Map<String, String> info = currencyProvider.getCurrencyInfo(
                      currency,
                    );
                    return PopupMenuItem<String>(
                      value: currency,
                      child: Row(
                        children: [
                          Text(
                            info['flag']!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(currency),
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
                          if (currencyProvider.selectedCurrency == currency)
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
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _firestoreService.getUserFinancialsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data: ${snapshot.error}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Trigger rebuild
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          Map<String, dynamic> userData = snapshot.data ?? {};
          double balance = (userData['balance'] ?? 0.0).toDouble();
          double income = (userData['income'] ?? 0.0).toDouble();
          double expenses = (userData['expenses'] ?? 0.0).toDouble();
          double savings = (userData['savings'] ?? 0.0).toDouble();
          double totalInstallments = (userData['totalInstallments'] ?? 0.0)
              .toDouble();

          double allocationPercentage = _calculateAllocationPercentage(
            balance,
            income,
          );

          return Consumer<CurrencyProvider>(
            builder: (context, currencyProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Current Balance
                    const Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyProvider.formatAmount(balance),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Circular Progress Indicator
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
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
                          // Progress circle
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return SizedBox(
                                width: 200,
                                height: 200,
                                child: CircularProgressIndicator(
                                  value:
                                      (allocationPercentage / 100) *
                                      _progressAnimation.value,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.transparent,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF4CAF50),
                                      ),
                                ),
                              );
                            },
                          ),
                          // Center text
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return Text(
                                    '${(allocationPercentage * _progressAnimation.value).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ),
                              const Text(
                                'Allocated',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Money Breakdown
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Money Breakdown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Income
                          _buildBreakdownItem(
                            icon: Icons.trending_up,
                            color: const Color(0xFF4CAF50),
                            label: 'Income',
                            amount: currencyProvider.formatAmount(income),
                          ),
                          const SizedBox(height: 16),

                          // Expenses
                          _buildBreakdownItem(
                            icon: Icons.trending_down,
                            color: const Color(0xFFFF5722),
                            label: 'Expenses',
                            amount: currencyProvider.formatAmount(expenses),
                          ),
                          const SizedBox(height: 16),

                          // Savings
                          _buildBreakdownItem(
                            icon: Icons.savings,
                            color: const Color(0xFF2196F3),
                            label: 'Savings',
                            amount: currencyProvider.formatAmount(savings),
                          ),

                          if (totalInstallments > 0) ...[
                            const SizedBox(height: 16),
                            // Installments
                            _buildBreakdownItem(
                              icon: Icons.payment,
                              color: const Color(0xFFFF9800),
                              label: 'Installments',
                              amount: currencyProvider.formatAmount(
                                totalInstallments,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Bottom Navigation
                    Container(
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
                                  builder: (context) =>
                                      const AddInstallmentScreen(),
                                ),
                              );
                            },
                          ),
                          _buildNavItem(
                            icon: Icons.account_balance_wallet,
                            label: 'Balance',
                            isActive: false,
                            onTap: () {
                              // Already on balance screen
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBreakdownItem({
    required IconData icon,
    required Color color,
    required String label,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
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
