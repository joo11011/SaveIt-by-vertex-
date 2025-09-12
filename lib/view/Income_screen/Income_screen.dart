import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:savelt_app/view/Income_screen/widgets/add_income_button.dart';
import 'package:savelt_app/view/Income_screen/widgets/income_list.dart';

import '../Add_new_income_screen/Add_new_income_screen.dart';
import '../Home_screen/Home_screen.dart';

class income_screen extends StatelessWidget {
  // final List<Map<String, dynamic>> incomes= [];
  income_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Income",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('incomes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final allincomes = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'tit': data['source_of_money'] ?? '',
                    'subtit':
                        '${data['currency'] ?? ''}${data['amount']?.toStringAsFixed(2) ?? '0'}',
                    'amount': (data['amount'] as num).toDouble(),
                    'icon': data['source_of_money'] == 'Visa'
                        ? Icons.credit_card
                        : Icons.attach_money,
                  };
                }).toList();
                return income_list(incomes: allincomes);
              },
            ),
          ),
          AddIncomeButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewIncomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
