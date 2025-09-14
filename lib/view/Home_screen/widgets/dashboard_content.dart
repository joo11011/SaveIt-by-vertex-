import 'package:flutter/material.dart';
import 'package:savelt_app/view/Expenses_screen/Expenses_screen.dart';
import 'package:savelt_app/view/Home_screen/widgets/grid_item.dart';
import 'package:savelt_app/view/Home_screen/widgets/remaining_balance_card.dart';
import 'package:savelt_app/view/Income_screen/Income_screen.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RemainingBalanceCard(
          balance: '5,000',
          currency: 'SAR',
          income: '10,000',
          expenses: '5,000',
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
                title: 'Income',
                amount: '10,000 SAR',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => income_screen()),
                  );
                },
              ),
              GridItem(
                icon: Icons.arrow_outward_sharp,
                title: 'Expenses',
                amount: '5,000 SAR',
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpensesScreen()),
                  );
                },
              ),
              GridItem(
                icon: Icons.account_balance_wallet,
                title: 'Savings',
                amount: '1,000 SAR',
                color: Colors.blue,
              ),
              GridItem(
                icon: Icons.payment,
                title: 'Installments',
                amount: '2,000 SAR',
                color: Colors.yellow,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
