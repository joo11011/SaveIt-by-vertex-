// Refactored lib/view/Income_screen/Income_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:savelt_app/view/Income_screen/widgets/add_income_button.dart';
import 'package:savelt_app/view/Income_screen/widgets/income_list.dart';

import '../../services/income_service.dart';
import '../Add_new_income_screen/Add_new_income_screen.dart';
import '../Home_screen/Home_screen.dart';

// Removed unused import: 'package:firebase_core/firebase_core.dart'

class income_screen extends StatelessWidget {
  const income_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final IncomeService _incomeService = IncomeService();
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
          'income'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _incomeService.getUserIncomesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final allincomes = snapshot.data ?? [];
                if (allincomes.isEmpty) {
                  return Center(child: Text('No income added yet'));
                }
                return income_list(
                  incomes: allincomes,
                  docIds: allincomes.map((e) => e['id'] as String).toList(),
                );
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